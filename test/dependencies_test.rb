require 'test_helper'

class StaleDependenciesTest < ActiveSupport::TestCase
  setup do
    @cache = Stale.configuration.cache = mock('cache')
    @interface = Stale.interface
  end

  teardown do
    Stale.configure
  end

  test "registers no dependencies for a key without models" do
    @interface.expects(:register_dependency).never
    @interface.register_dependencies(['test'])
  end

  test "registers dependencies for a key with models" do
    @interface.expects(:register_dependency).with('model:1', 'test:model:1:model:2')
    @interface.expects(:register_dependency).with('model:2', 'test:model:1:model:2')
    @interface.register_dependencies(['test', 'model:1', 'model:2'])
  end

  test "expires dependencies for a model and collection" do
    @interface.expects(:expire_dependencies_from_list).with('model:1:dependencies')
    @interface.expects(:expire_dependencies_from_list).with('model::dependencies')
    @interface.expire_dependencies('model:1')
  end

  test "registers dependencies for models" do
    @interface.expects(:add_dependency_to_list).with('model:1:dependencies', 'test:model:1')
    @interface.register_dependency('model:1', 'test:model:1')
  end

  test "adds dependencies to lists" do
    @cache.expects(:modify).with('model:1:dependencies').yields(nil).returns(true)
    @interface.add_dependency_to_list('model:1:dependencies', 'test:model:1')
  end

  test "expires dependencies from lists" do
    keys = ['test:model:1', 'test:model:1:attributes']
    @cache.expects(:get).with('model:1:dependencies').returns(keys)
    @cache.expects(:delete).with(*keys)
    @interface.expire_dependencies_from_list('model:1:dependencies')
  end
end
