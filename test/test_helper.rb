require 'stale'

require 'test/unit'
require 'mocha/setup'

class StaleTestController
  include Stale::Controller

  attr_accessor :perform_caching

  def controller_name
    'stale_test_controller'
  end
end

class StaleTestModel
  include Stale::Model

  attr_reader :id

  def initialize(id)
    @id = id
  end

  def to_param
    id
  end
end

class StaleTestView
  include Stale::View

  attr_reader :controller, :output_buffer

  def initialize
    @controller = StaleTestController.new
  end

  def safe_concat(value)
    @output_buffer = value
  end

  def build_stale_fragment
    yield
  end
end
