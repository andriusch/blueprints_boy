---
layout: application
title: Strategies
---

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

# Factories

When adding [factories](/blueprints_boy/factories) you can define class and strategy that particular factory is used for.

{% highlight ruby %}
BlueprintsBoy.factories.add(Fruit, :create) { |data| data.factory.create!(data.attributes) }
BlueprintsBoy.factories.add(Fruit, :update) { |data| blueprint_data(data.name).update_attributes!(data.options) }
{% endhighlight %}
