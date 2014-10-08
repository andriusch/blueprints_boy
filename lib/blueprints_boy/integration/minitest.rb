module BlueprintsBoy::MinitestHelper
  def before_setup
    super
    BlueprintsBoy.manager.setup(self)
  end

  def after_teardown
    super
    BlueprintsBoy.manager.teardown
  end

  module ClassMethods
    def build(*args)
      before do
        build *args
      end
    end
  end
end

MiniTest::Unit::TestCase.send :include, BlueprintsBoy::Helper, BlueprintsBoy::MinitestHelper if defined?(MiniTest::Unit::TestCase)
MiniTest::Test.send :include, BlueprintsBoy::Helper, BlueprintsBoy::MinitestHelper if defined?(MiniTest::Test)
MiniTest::Spec.send :extend, BlueprintsBoy::MinitestHelper::ClassMethods if defined?(MiniTest::Spec)
