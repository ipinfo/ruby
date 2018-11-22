module IPinfo
  class CacheInterface
    class InterfaceNotImplemented < StandardError; end
    def get(key)
      raise InterfaceNotImplemented
    end

    def set(key, value)
      raise InterfaceNotImplemented
    end

    def contains?(key)
      raise InterfaceNotImplemented
    end
  end
end
