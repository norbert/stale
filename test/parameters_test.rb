require 'test_helper'

class StaleParametersTest < ActiveSupport::TestCase
  def controller_mock
    mock('controller', :controller_name => 'test')
  end

  setup do
    @configuration = Stale::Configuration.new
  end

  test "defines named parameters with block" do
    @configuration.define_named_parameter :controller_name do |controller|
      controller.controller_name
    end

    assert_equal 'test', @configuration.key_for_parameter(:controller_name, controller_mock)
  end

  test "defines named parameters without block" do
    @configuration.define_named_parameter :controller_name

    assert_equal 'test', @configuration.key_for_parameter(:controller_name, controller_mock)
  end

  test "converts model parameters to keys" do
    assert_equal 'stale_test_model:1', @configuration.key_for_parameter(StaleTestModel.new(1))
  end

  test "converts class parameters to keys" do
    assert_equal 'stale_test_model:', @configuration.key_for_parameter(StaleTestModel)
  end

  test "converts array parameters to keys" do
    assert_equal 'stale_test_model:2', @configuration.key_for_parameter([StaleTestModel, 2])
  end

  test "converts string parameters to keys" do
    assert_equal 'test', @configuration.key_for_parameter('test')
  end

  test "raises when converting unknown named parameters to keys" do
    # FIXME
    assert_raises(NoMethodError) {
      @configuration.key_for_parameter(:test, mock('controller'))
    }
  end

  test "converts multiple parameters to keys in order" do
    @configuration.define_named_parameter :controller_name

    assert_equal ['test', 'index'], @configuration.key_for_parameters([:controller_name, 'index'], controller_mock)
  end
end
