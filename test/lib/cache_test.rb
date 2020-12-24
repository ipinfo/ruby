# frozen_string_literal: true

require 'test_helper'
require_relative '../../lib/ipinfo/cache/default_cache'

class IPinfo::CacheTest < Minitest::Test
    def test_get
        cache = IPinfo::DefaultCache.new(5, 3)
        cache.set(:a, 2)
        cache.set(:b, 3)
        assert_equal 2, cache.get(:a)
        assert_equal 3, cache.get(:b)
    end

    def test_contains?
        cache = IPinfo::DefaultCache.new(5, 3)
        assert_equal false, cache.contains?(:a)
        cache.set(:a, 2)
        assert_equal true, cache.contains?(:a)
    end

    def test_max_size
        cache = IPinfo::DefaultCache.new(5, 2)
        cache.set(:a, 2)
        cache.set(:b, 3)
        assert_equal true, cache.contains?(:a)
        assert_equal true, cache.contains?(:b)
        cache.set(:c, 3)
        cache.set(:d, 5)
        assert_equal false, cache.contains?(:a)
        assert_equal false, cache.contains?(:b)
        assert_equal true, cache.contains?(:c)
        assert_equal true, cache.contains?(:d)
    end

    def test_ttl
        cache = IPinfo::DefaultCache.new(0.1, 2)
        cache.set(:a, 2)
        assert_equal true, cache.contains?(:a)
        sleep(0.2)
        assert_equal false, cache.contains?(:a)
    end
end
