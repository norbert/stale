require 'test_helper'

class StaleInterfaceTest < ActiveSupport::TestCase
  setup do
    @interface = Stale.interface
  end

  test "delegates converting parameters to configuration" do
    controller_mock = mock('controller')
    Stale.configuration.expects(:key_for_parameters).with(['test'], controller_mock)
    @interface.key_for_parameters(['test'], controller_mock)
  end

  test "generates keys for models" do
    assert_equal 'stale_test_model:1', @interface.key_for_model(StaleTestModel, 1)
    assert_equal 'stale_test_model:', @interface.key_for_model(StaleTestModel)
    assert_equal 'stale_test_model:1', @interface.key_for_model('stale_test_model', 1)
    assert_equal 'stale_test_model:1:attributes', @interface.key_for_model('stale_test_model', 1, :attributes)
  end

  test "converts key arrays to strings" do
    assert_equal 'test:model:1', @interface.key_as_string(['test', 'model:1'])
  end

  test "extracts model keys from arrays" do
    assert_equal ['model:1', 'model:2:attributes'], @interface.models_from_key(['test', 'model:1', 'model:2:attributes'])
  end

  test "extracts collections from model keys" do
    assert_equal 'model:', @interface.collection_from_key('model:1')
  end
end
