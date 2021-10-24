---
layout: application
title: Basic usage
---

# Setup

The easiest way to install this gem is simply adding this line to your Gemfile:

{% highlight ruby %}
gem 'blueprints_boy'
{% endhighlight %}


If you're not using bundler, then you can install it through command line

{% highlight ruby %}
gem install blueprints
{% endhighlight %}

Blueprints boy is activated by calling BlueprintsBoy.enable at the bottom of your spec_helper/test_helper.

{% highlight ruby %}
# spec/spec_helper.rb
BlueprintsBoy.enable
{% endhighlight %}

# Blueprints file

Blueprints file is the file that contains all definitions of blueprints. This can either be single file or whole folder
if you have many blueprints.

By default blueprints are searched in these files in this particular order in application root (which is either Rails.root if it's defined or current folder by default):

{% include file_patterns.markdown %}

You can set root option to override application root and filename option to pass custom filename pattern. For more information see [configuration](/blueprints_boy/configuration)

## Basic definitions

Basic definitions of blueprints look like this:

{% highlight ruby %}
blueprint :apple do
  Fruit.new 'apple'
end

blueprint :orange do
  Fruit.new 'orange'
end

depends_on(:apple, :orange).blueprint :fruitbowl do
  FruitBowl.new apple, orange
end
{% endhighlight %}

Note that in :fruitbowl blueprint we define depenendencies on other blueprints, meaning that once we build
:fruitbowl, then :apple, :orange and all their dependencies will also be built.

## Usage

You can use your defined blueprints in specs(tests) like this:

{% highlight ruby %}
describe Fruit, "apple" do
  before do
    build :apple
  end

  it "should be an apple" do
    expect(apple.species).to eq('apple')
  end
end

describe FruitBowl, "with and apple and an orange" do
  before do
    build :fruitbowl
  end

  it "should have 2 fruits" do
    expect(fruitbowl.fruits).to eq([apple, orange])
  end
end
{% endhighlight %}

Whatever your blueprint block returns can be reached using method with the same name as blueprint.

All blueprints are built only once, so:

{% highlight ruby %}
build(:apple).equal? build(:apple) #=> true
{% endhighlight %}

## Advanced Usage

Its just ruby, right? So go nuts:

{% highlight ruby %}
1.upto(9) do |i|
  blueprint("user_#{i}") do
    User.create! :name => "user#{i}"
  end
end
{% endhighlight %}
