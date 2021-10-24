---
layout: application
title: Configuration
---

# Accessing configuration

There are two ways to configure blueprints boy. First is using yielded configuration object in BlueprintsBoy.enable:

{% highlight ruby %}
BlueprintsBoy.enable do |config|
  config.filenames = 'data/blueprints.rb'
end
{% endhighlight %}

Another way is by calling BlueprintsBoy.config directly:

{% highlight ruby %}
BlueprintsBoy.config.filenames = 'data/blueprints.rb'
{% endhighlight %}

# Configuration options

There are several things BlueprintsBoy allows to configure:

## global

By default blueprints starts transactions on an empty database. This option allows you to specify blueprints that are
built before starting transaction. This means that data for them will be available in all tests and they will need to be
built only once (not once before each test case but once before test suite). Note that if you're not using transactions
this option should not be used as it will not speedup your test suite.

{% highlight ruby %}
BlueprintsBoy.enable do |config|
  config.global = :user, :post
end
{% endhighlight %}

## root
BlueprintsBoy tries it's best to determine the root directory of your application. It will use Rails.root if it's 
available or assume current dir otherwise. However you may want to customize it to any other dir you want. Root accepts 
String or Pathname objects.

{% highlight ruby %}
BlueprintsBoy.enable do |config|
  config.root = Pathname.new(__FILE__).dirname
end
{% endhighlight %}

## filenames

Allows setting custom patterns of files that contain your blueprints (in case one of automatic ones doesn't fit your
needs). This can either be a single pattern or array of patterns. By default these patterns are used:

{% include file_patterns.markdown %}

{% highlight ruby %}
BlueprintsBoy.enable do |config|
  config.filenames = 'data/blueprints.rb'
end
{% endhighlight %}

## transactions

By default BlueprintsBoy runs in transactional mode. This means that before each test/spec transaction is opened. Then 
you create, manipulate and destroy data using methods provided by BlueprintsBoy or any other means. After each test 
transaction is dropped thus returning your database state to the one before transaction was started. However in some 
cases transactions need to be turned off (eg. [using non transactional database](/blueprints_boy/orms) or running using 
cucumber with selenium). This option allows you to do that. Note that turning off transactions will usually slow your 
tests severely.

{% highlight ruby %}
BlueprintsBoy.enable do |config|
  config.transactions = false
end
{% endhighlight %}

## cleaner

By default BlueprintsBoy uses DatabaseCleaner for cleaning up before test suite and each test. If for some reason you
want to use something else it's possible to use custom cleaner for that. It's best to check BlueprintsBoy::Cleaner
class for an example on how to roll your own solution.

{% highlight ruby %}
BlueprintsBoy.enable do |config|
  config.cleaner = MyCleaner.new
end
{% endhighlight %}
