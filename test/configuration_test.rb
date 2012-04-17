require 'test_helper'

class StaleConfigurationTest < ActiveSupport::TestCase
  teardown do
    Stale.configure
  end

  test "allows configuration with block" do
    result = nil
    Stale.configure do |config|
      result = config
    end
    assert_equal result, Stale.configuration
  end

  test "has accessors for options" do
    @configuration = Stale::Configuration.new
    value = 1.hour
    assert_equal value, @configuration[:expiration_time] = value
    assert_equal value, @configuration[:expiration_time]
  end

  test "provides accessors for cache and interface" do
    @configuration = Stale::Configuration.new
    @cache = mock('cache')
    @interface = mock('interface')
    @configuration.cache = @cache
    @configuration.interface = @interface
    Stale.configuration = @configuration
    assert_equal @cache, Stale.cache
    assert_equal @interface, Stale.interface
  end
end
