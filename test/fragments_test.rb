require 'test_helper'

class StaleFragmentsTest < ActiveSupport::TestCase
  setup do
    @cache = Stale.configuration.cache = mock('cache')
    @view = StaleTestView.new
  end

  teardown do
    Stale.configure
  end

  test "reads fragments by key" do
    @cache.expects(:get).with('controller:action').returns('test')
    assert_equal 'test', @view.read_stale_fragment(['controller', 'action'])
  end

  test "writes fragments by key with default expiration time" do
    @cache.expects(:set).with('controller:action', 'test', Stale.configuration[:expiration_time])
    @view.write_stale_fragment(['controller', 'action'], 'test')
  end

  test "writes fragments by key with given expiration time" do
    @cache.expects(:set).with('controller:action', 'test', 30)
    @view.write_stale_fragment(['controller', 'action'], 'test', 30)
  end

  test "checks if fragments exist by reading" do
    @cache.expects(:get).with('controller:action').returns('test')
    assert @view.stale_fragment_exist?(['controller', 'action'])
  end
end
