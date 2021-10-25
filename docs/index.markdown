---
layout: application
title: Home
---
 
# Getting started
 
In `spec/spec_helper.rb` or `test/test_helper.rb`:

{% highlight ruby %}
Blueprints.enable
{% endhighlight %}

In spec/blueprint.rb or test/blueprint.rb:

{% highlight ruby %}
blueprint :apple do
Fruit.create!(species: 'apple')
end

# Or use a shorthand

factory(Fruit).blueprint :apple, species: 'apple'
{% endhighlight %}

In test case:

{% highlight ruby %}
it "has species 'apple'" do
  build :apple
  expect(apple.species).to eq('apple')
end
{% endhighlight %}
