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

  [1, 2, 3].each do |n|
    fixture("mock#{n}") { "mock#{n}" }

    fixture "blueprint#{n}" do |result|
      result ||= send("mock#{n}")
      BlueprintsBoy::Blueprint.new(empty_context, "blueprint#{n}") { result }
    end
  end

  fixture :manager do
    BlueprintsBoy::Manager.new
  end

  fixture :empty_context do
    BlueprintsBoy::Context.new(ROOT.join('spec/support/empty_file.rb').to_s, manager)
  end
end
