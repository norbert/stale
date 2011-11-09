module Stale
  class Configuration
    include Parameters

    DEFAULT_OPTIONS = {
      :expiration_time => 1.day,
      :key_prefix => 'stale:',
      :key_separator => ':',
      :model_key_separator => ':',
      :dependency_key_suffix => ':dependencies'
    }

    attr_accessor :cache, :interface
    attr_reader :options

    def initialize
      @options = DEFAULT_OPTIONS.clone
      @interface = Interface
    end

    def [](key)
      options[key]
    end

    def []=(key, value)
      options[key] = value
    end
  end

  mattr_accessor :configuration
  self.configuration = Configuration.new

  def self.configure(&block)
    configuration = Configuration.new
    yield configuration if block_given?
    self.configuration = configuration
  end

  def self.interface
    configuration.interface
  end

  def self.cache
    configuration.cache
  end
end
