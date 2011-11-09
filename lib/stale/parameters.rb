module Stale
  module Parameters
    def key_for_parameters(parameters, controller = nil)
      parameters.map { |parameter| key_for_parameter(parameter, controller) }
    end

    def key_for_parameter(parameter, controller = nil)
      if parameter.is_a?(Symbol)
        self.named_parameters[parameter].call(controller)
      elsif parameter.respond_to?(Model::IDENTIFIER)
        parameter.send(Model::IDENTIFIER)
      elsif parameter.is_a?(Class)
        Stale.interface.key_for_model(parameter)
      else
        parameter.to_param
      end
    end

    def define_named_parameter(method, &block)
      block = method.to_proc unless block_given?
      self.named_parameters[method] = block
    end
    alias_method :parameter, :define_named_parameter

    def named_parameters
      @named_parameters ||= {}
    end
  end
end
