require 'test_helper'

class StaleViewTest < ActiveSupport::TestCase
  setup do
    @view = StaleTestView.new
    @view.controller.perform_caching = true
  end

  test "builds and writes fragment when fragment does not exist" do
    key = ['test']
    @view.expects(:read_stale_fragment).with(key).returns(nil)
    @view.expects(:write_stale_fragment).with(key, 'perform')

    @view.stale(key) {
      'perform'
    }
    assert_equal 'perform', @view.output_buffer
  end

  test "does not build fragment when fragment exists" do
    key = ['test']
    @view.expects(:read_stale_fragment).with(key).returns('test')
    @view.expects(:write_stale_fragment).never

    assert_nothing_thrown {
      @view.stale(key) {
        throw :perform
      }
    }
    assert_equal 'test', @view.output_buffer
  end

  test "builds fragment without reading when caching is disabled" do
    key = ['test']
    @view.controller.perform_caching = false
    @view.expects(:read_stale_fragment).never
    @view.expects(:write_stale_fragment).never

    @view.stale(key) {
      'perform'
    }
    assert_equal 'perform', @view.output_buffer
  end

  test "registers dependencies for the converted key" do
    key = [:test]
    Stale.interface.expects(:key_for_parameters).with(key, @view.controller).returns(['test'])
    Stale.interface.expects(:register_dependencies).with(['test'])
    @view.expects(:read_stale_fragment).with(['test']).returns('test')

    @view.stale(key) {
      nil
    }
  end
end
