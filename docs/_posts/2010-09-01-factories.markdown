---
layout: application
title: Factories
---

# Using factories

Factories allows you to extract common functionality from blueprints building. For example let's say you have:

{% highlight ruby %}
blueprint :apple do
  Fruit.new 'apple'
end

blueprint :orange do
  Fruit.new 'orange'
end
{% endhighlight %}

Instead of all that you could extract a factory and all the code would look like this:

{% highlight ruby %}
BlueprintsBoy.factories.add(Fruit, :create) { |data| data.factory.new(data.attributes[:name]) }

factory(Fruit).blueprint :apple, name: 'apple'
factory(Fruit).blueprint :orange, name: 'orange'
{% endhighlight %}

Where `:create` is a [strategy](/blueprints_boy/strategies) that this factory is defined for. This can then be shortened 
even more by:

{% highlight ruby %}
BlueprintsBoy.factories.add(Fruit, :create) { |data| data.factory.new(data.attributes[:name]) }

factory Fruit do
  blueprint :apple, name: 'apple'
  blueprint :orange, name: 'orange'
end
{% endhighlight %}

This same factory would even work for subclasses of Fruit! So you could write factories for your own ORMs. For examples
see [ActiveRecord factories](https://github.com/andriusch/blueprints_boy/blob/master/lib/blueprints_boy/integration/active_record.rb)
and [Mongoid factories](https://github.com/andriusch/blueprints_boy/blob/master/lib/blueprints_boy/integration/mongoid.rb)

# ORM factories

Since they are so widely used, BlueprintsBoy provides factories for ActiveRecord (>= 3.1) and Mongoid (>= 2.0) out of
the box.

{% highlight ruby %}
# Somewhere in application
class Fruit < ActiveRecord::Base
end

# Blueprints file
factory(Fruit).blueprint :orange, name: 'orange'
{% endhighlight %}
