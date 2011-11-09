module Stale
  module View
    include Fragments

    def stale(parameters, &block)
      if !controller.perform_caching
        safe_concat(build_stale_fragment(&block))
        return
      end

      key = Stale.interface.key_for_parameters(parameters, controller)
      Stale.interface.register_dependencies(key)

      unless fragment = read_stale_fragment(key)
        fragment = build_stale_fragment(&block)
        write_stale_fragment(key, fragment)
      end

      safe_concat(fragment)
      nil
    end

    private
    def build_stale_fragment(&block)
      # copied from actionpack/lib/action_view/helpers/cache_helper.rb
      pos = output_buffer.length
      yield
      if output_buffer.html_safe?
        safe_output_buffer = output_buffer.to_str
        fragment = safe_output_buffer.slice!(pos..-1)
        self.output_buffer = output_buffer.class.new(safe_output_buffer)
      else
        fragment = output_buffer.slice!(pos..-1)
      end

      fragment
    end
  end
end
