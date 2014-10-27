---
layout: application
title: Strategies
---

# Building using strategies

Blueprints boy allows defining blueprint to be built using different strategies. These three are the most common:

Name          | Description
--------------|------------
`:create`     | Default strategy, initializes object and saves it in database
`:update`     | Default strategy for already build blueprints, updates object with new options that are passed
`:new`        | Only initialize object, don't save it to database
`:attributes` | Only return attributes that would be used to build blueprint

# Defining strategies

Each blueprint can define multiple strategies on how it can be built. For example this blueprint

{% highlight ruby %}
blueprint :sample do
  12
end.blueprint :twice do
  24
end
{% endhighlight %}

will have 2 strategies: `:create` and `:twice`. Depending on what strategy you choose when building blueprint you will
get different result. You can choose strategy by using `build_with :strategy, :blueprint`.

# Updating blueprint

Building same blueprint twice with different options will result in :update strategy being used the second time.

{% highlight ruby %}
blueprint :apple do
  Fruit.new 'apple'
end.blueprint :update do |data|
  apple.name = data[:name]
end

# Spec
build :apple
apple.name.should == 'apple'
build :apple => {name: 'red apple'}
apple.name.should == 'red apple'
{% endhighlight %}

# Building multiple times

If you want to build same blueprint multiple times (creating object that blueprint creates multiple times). You can use
`build!` method.

{% highlight ruby %}
blueprint :apple do
  Fruit.new 'apple'
end

# Spec
apple1 = build!(:apple)
apple2 = build!(:apple)
# Different objects but both are instances of Fruit and have name 'apple'
apple1.object_id.should_not == apple2.object_id
{% endhighlight %}

# Factories

When adding [factories](/blueprints_boy/factories) you can define class and strategy that particular factory is used for.

{% highlight ruby %}
BlueprintsBoy.factories.add(Fruit, :create) { |data| data.factory.create!(data.attributes) }
BlueprintsBoy.factories.add(Fruit, :update) { |data| blueprint_data(data.name).update_attributes!(data.options) }
{% endhighlight %}

# Summary of build methods

Method           | Strategy
-----------------|-------------------
build            | `:create` or [`:update`](/blueprints_boy/strategies#updating-blueprint)
build!           | `:create`
build_new        | `:new`
build_attributes | `:attributes`
build_with       | Passed as first argument
