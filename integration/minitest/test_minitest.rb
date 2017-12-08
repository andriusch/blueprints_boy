require 'bundler/setup'
require 'minitest/autorun'
require 'blueprints_boy'

BlueprintsBoy.enable do |config|
  config.root = File.dirname(__FILE__)
  config.global = :global_cherry
end

class TestMinitest < MiniTest::Test
  def test_build
    build :apple
    assert_equal 'apple', apple
  end

  def test_clearup
    assert_nil blueprint_data(:apple)
  end

  def test_build_again
    build :apple
    assert_equal 'apple', apple
  end

  def test_global
    assert_equal 'cherry', global_cherry
  end
end

class TestMinitestWithOverrides < MiniTest::Test
  def setup
    blueprint :apple do
      'red apple'
    end
  end

  def test_overrides
    assert_equal 'red apple', apple
  end
end
