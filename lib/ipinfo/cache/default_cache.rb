require 'ipinfo/cache/cache_interface'
require 'lrucache'

module IPinfo
  class DefaultCache < CacheInterface

    def initialize(ttl, max_size)
      @cache = LRUCache.new(:ttl => ttl, :max_size => max_size)
    end

    def get(key)
      @cache[key]
    end

    def set(key, value)
      @cache[key] = value
    end

    def contains(key)
      !@cache[key].nil?
    end
  end
end
