require 'mocha'

module Fixtures
  include Mocha::API

  def self.fixture(name, &block)
    iv_name = :"@#{name}"
    define_method(name) do |*args|
      instance_variable_set(iv_name, instance_exec(*args, &block)) unless instance_variable_defined?(iv_name)
      instance_variable_get(iv_name)
    end
  end

  fixture :env do
    Object.new.tap { |object| object.extend(BlueprintsBoy::Helper) }
  end

  fixture(:mock1) { mock('mock1') }

  fixture :blueprint1 do |result|
    result ||= mock1
    BlueprintsBoy::Blueprint.new(:blueprint1) { result }
  end
end
