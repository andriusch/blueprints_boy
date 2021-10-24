---
layout: application
title: Attributes & options
---

# Options

Each blueprint can be built using options hash.

{% highlight ruby %}
# In blueprints file:
blueprint :options do |data|
  data.options
end

# In test case
it "should return options" do
  build :options => {:attribute => 'value'}
  expect(options).to eq(:attribute => 'value')
end
{% endhighlight %}

# Attributes

Each blueprint may have attributes defined. Attributes can be set using second argument, prefix, postfix and block 
forms. Attributes can be accessed using `data.attributes` inside blueprint block.

{% highlight ruby %}
blueprint :apple, :name => 'apple' do |data|
  Fruit.create! data.attributes
end

attributes(:name => 'apple').blueprint :apple do |data|
  Fruit.create! data.attributes
end

blueprint :apple do |data|
  Fruit.create! data.attributes
end.attributes(:name => 'apple')

attributes(:name => 'apple') do
  # Any blueprints inside will have their attributes merged with {:name => 'apple'}
  blueprint :apple do |data|
    Fruit.create! data.attributes
  end

  attributes(:size => 'big').blueprint :big_apple do |data|
    # attributes == {:name => 'apple', :size => 'big'}
    Fruit.create! data.attributes
  end
end
{% endhighlight %}

Attributes are automatically merged with options at build time, so given blueprints above, this test would pass:

{% highlight ruby %}
it "should merge options to attributes" do
  build :big_apple => {:size => 'small'}
  expect(@big_apple.name).to eq('apple')
  # Note that passed options overwrite attributes
  expect(@big_apple.size).to eq('small')
end
{% endhighlight %}
