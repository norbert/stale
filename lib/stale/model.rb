module Stale
  module Model
    IDENTIFIER = :stale_key

    def stale_id
      to_param
    end

    def stale_key
      Stale.interface.key_for_model(self.class, stale_id)
    end

    def expire_stale_dependencies
      Stale.interface.expire_dependencies(stale_key)
    end
  end
end
