module Stale
  class Cache
    attr_reader :data

    def initialize(data)
      @data = data
    end

    def get(key)
      data.get(key_with_prefix(key))
    end

    def set(key, value, ttl = nil)
      data.set(key_with_prefix(key), value, ttl)
    end

    def add(key, value, ttl = nil)
      data.add(key_with_prefix(key), value, ttl)
    end

    def delete(*keys)
      keys.each do |key|
        data.delete(key_with_prefix(key))
      end
    end

    def modify(key, ttl = nil, &block)
      stored = false
      retries = 0

      while !stored
        stored = data.cas(key_with_prefix(key), ttl, &block)

        if stored.nil?
          stored = add(key, block.call(nil), ttl)
        elsif stored == false
          retries += 1
        end
      end

      stored
    end

    private
    def key_with_prefix(key)
      Stale.configuration[:key_prefix] + key
    end
  end
end
