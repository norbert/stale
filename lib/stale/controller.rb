module Stale
  module Controller
    include Fragments

    def stale(parameters, &block)
      if !perform_caching
        yield
        return
      end

      key = Stale.interface.key_for_parameters(parameters, self)
      Stale.interface.register_dependencies(key)

      if !stale_fragment_exist?(key)
        yield
        nil
      end
    end
  end
end
