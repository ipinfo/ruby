# frozen_string_literal: true

require 'ipinfo/cache/cache_interface'
require 'lru_redux'

class IPinfo::DefaultCache < IPinfo::CacheInterface
    def initialize(ttl, max_size)
        @cache = LruRedux::TTL::Cache.new(max_size, ttl)
    end

    def get(key)
        @cache[key]
    end

    def set(key, value)
        @cache[key] = value
    end

    def contains?(key)
        !@cache[key].nil?
    end
end
