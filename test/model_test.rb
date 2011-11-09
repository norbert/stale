require 'test_helper'

class StaleModelTest < ActiveSupport::TestCase
  test "expires dependencies for model key" do
    @model = StaleTestModel.new(1)
    Stale.interface.expects(:expire_dependencies).with(@model.stale_key)

    @model.expire_stale_dependencies
  end
end
