# BlueprintsBoy

[![Build status](https://github.com/andriusch/blueprints_boy/actions/workflows/ruby.yml/badge.svg)](https://github.com/andriusch/blueprints_boy/actions/workflows/ruby.yml)
[![Code Climate](https://codeclimate.com/github/andriusch/blueprints_boy/badges/gpa.svg)](https://codeclimate.com/github/andriusch/blueprints_boy/badges)

The ultimate DRY and fast solution to loading test data in Ruby and Rails. Blueprints allows you to create and manage 
data for tests in simple but powerful ways.

## Documentation

Add gem to you `Gemfile`:
```ruby
gem 'database_cleaner-active_record'
gem 'blueprints_boy'
```

In `spec/spec_helper.rb` or `test/test_helper.rb`:

```ruby
Blueprints.enable
```

In spec/blueprints.rb or test/blueprints.rb:

```ruby
blueprint :apple do
  Fruit.create!(species: 'apple')
end

# Or use a shorthand

factory(Fruit).blueprint :apple, species: 'apple'
```

In test case:

```ruby
it "has species 'apple'" do
  build :apple
  expect(apple.species).to eq('apple')
end
```

For documentation please visit [andriusch.github.io/blueprints_boy](http://andriusch.github.io/blueprints_boy)

## Development

* Clone the repository
* Setup dependencies
  ```shell
  bundle
  appraisal install
  ```
* Do your changes
* Run tests
  ```
  docker-compose up
  rubocop
  appraisal rake
  ```
* Create pull request

## Credits

Andrius Chamentauskas <andrius.chamentauskas@gmail.com>

Some ideas are based on hornsby scenario plugin by Lachie Cox, which was based on code found on 
[errtheblog.com/posts/61-fixin-fixtures](http://errtheblog.com/posts/61-fixin-fixtures)

## License

MIT, see LICENCE
