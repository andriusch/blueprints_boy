---
layout: application
title: Dependencies
---

Any blueprint can have dependencies. Dependencies mean that that building one blueprint will also build another. Note
that each blueprint can only be built once.

# Defining dependencies

There are several ways to define dependencies:

## Depends on

First way is using `depends_on` method which can be used in three different forms: prefix, postfix and block.

{% highlight ruby %}
blueprint(:fruits).depends_on(:apple, :orange)

depends_on(:apple, :orange).blueprint(:fruits)

depends_on(:apple, :orange) do
  # Any blueprints we define inside this block will depends on :apple and :orange
  blueprint :fruits
  blueprint :round_fruits
end
{% endhighlight %}

## Attribute dependency

This way we not only define dependency but also assign it to attribute of another blueprint.

{% highlight ruby %}
# Define blueprint named :apple_tree which when built will build :apple and apple to :fruit
factory(Tree).blueprint :apple_tree, :fruit => apple

# Define blueprint named :apple_tree which when built will build :apple_fruit with options
# {:color => 'red'} and assign apple to :fruit
factory(Tree).blueprint :apple_tree, :fruit => apple(:apple_fruit, :color => 'red')

# Define blueprint name :apple_tree which when built will build :apple and assign
# apple.name to :fruit_name
factory(Tree).blueprint :apple_tree, :fruit_name => d(:apple).name
{% endhighlight %}

## Grouping

This is just a shortcut that allows grouping multiple blueprints to one pack.

{% highlight ruby %}
group :fruits => [:apple, :orange]

# spec
build :fruits
fruits.should == [apple, orange]
{% endhighlight %}
