require 'test_helper'

class StaleControllerTest < ActiveSupport::TestCase
  setup do
    @controller = StaleTestController.new
    @controller.perform_caching = true
  end

  test "runs block when fragment does not exist" do
    key = ['test']
    @controller.expects(:stale_fragment_exist?).with(key).returns(false)

    assert_throws(:perform) {
      @controller.stale(key) {
        throw :perform
      }
    }
  end

  test "does not run block when fragment exists" do
    key = ['test']
    @controller.expects(:stale_fragment_exist?).with(key).returns(true)

    assert_nothing_thrown {
      @controller.stale(key) {
        throw :perform
      }
    }
  end

  test "runs block when caching is disabled" do
    key = ['test']
    @controller.perform_caching = false
    @controller.expects(:stale_fragment_exist?).never

    assert_throws(:perform) {
      @controller.stale(key) {
        throw :perform
      }
    }
  end

  test "registers dependencies for the converted key" do
    key = [:test]
    Stale.interface.expects(:key_for_parameters).with(key, @controller).returns(['test'])
    Stale.interface.expects(:register_dependencies).with(['test'])
    @controller.expects(:stale_fragment_exist?).with(['test']).returns(false)

    @controller.stale(key) {
      nil
    }
  end
end
