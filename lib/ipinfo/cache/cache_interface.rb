# frozen_string_literal: true

module IPinfo
    class CacheInterface
        class InterfaceNotImplemented < StandardError; end

        def get(_key)
            raise InterfaceNotImplemented
        end

        def set(_key, _value)
            raise InterfaceNotImplemented
        end

        def contains?(_key)
            raise InterfaceNotImplemented
        end
    end
end
