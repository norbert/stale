module Stale
  module Fragments
    def read_stale_fragment(key_array)
      key_string = Stale.interface.key_as_string(key_array)
      Stale.cache.get(key_string)
    end

    def write_stale_fragment(key_array, value, ttl = nil)
      ttl ||= Stale.configuration[:expiration_time]

      key_string = Stale.interface.key_as_string(key_array)
      Stale.cache.set(key_string, value, ttl)
    end

    def stale_fragment_exist?(key_array)
      !!read_stale_fragment(key_array)
    end
  end
end
