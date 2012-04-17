require 'test_helper'

class StaleCacheTest < ActiveSupport::TestCase
  setup do
    @data = mock('data')
    @cache = Stale::Cache.new(@data)

    Stale.configure do |config|
      config.cache = @cache
      config[:key_prefix] = 'test:'
    end
  end

  teardown do
    Stale.configure
  end

  test "performs get with prefix" do
    @data.expects(:get).with('test:key').returns('test')
    assert_equal 'test', @cache.get('key')
  end

  test "performs set with prefix" do
    @data.expects(:set).with('test:key', 'test', 30).returns(true)
    assert @cache.set('key', 'test', 30)
  end

  test "performs add with prefix" do
    @data.expects(:add).with('test:key', 'test', 30).returns(true)
    assert @cache.add('key', 'test', 30)
  end

  test "performs delete with prefix using multi block" do
    @data.expects(:multi).yields.returns(nil)
    @data.expects(:delete).with('test:key:1')
    @data.expects(:delete).with('test:key:2')
    assert_nil @cache.delete('key:1', 'key:2')
  end

  test "modifies keys with cas when set" do
    @data.expects(:cas).with('test:key', nil).yields(1).returns(true)
    assert @cache.modify('key') { |value| value + 1 }
  end

  test "modifies keys with add when not set" do
    @data.expects(:cas).with('test:key', 30).yields(nil).returns(nil)
    @data.expects(:add).with('test:key', 1, 30).returns(true)
    assert @cache.modify('key', 30) { |value| value.to_i + 1 }
  end

  test "modifies keys by retrying when cas fails" do
    @data.expects(:cas).twice.with('test:key', 30).yields(1).returns(false).then.returns(true)
    assert @cache.modify('key', 30) { |value| value + 1 }
  end
end
