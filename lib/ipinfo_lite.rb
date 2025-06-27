# frozen_string_literal: true

require 'ipinfo/adapter'
require 'ipinfo/cache/default_cache'
require 'ipinfo/errors'
require 'ipinfo/response'
require_relative 'ipinfo/ipAddressMatcher'
require_relative 'ipinfo/countriesData'
require 'ipaddr'
require 'cgi'

module IPinfoLite
    include CountriesData
    DEFAULT_CACHE_MAXSIZE = 4096
    DEFAULT_CACHE_TTL = 60 * 60 * 24
    RATE_LIMIT_MESSAGE = 'To increase your limits, please review our ' \
                         'paid plans at https://ipinfo.io/pricing'
    # Base URL to get country flag image link.
    # "PK" -> "https://cdn.ipinfo.io/static/images/countries-flags/PK.svg"
    COUNTRY_FLAGS_URL = 'https://cdn.ipinfo.io/static/images/countries-flags/'

    class << self
        def create(access_token = nil, settings = {})
            IPinfo::IPinfoLite.new(access_token, settings)
        end
    end
end

class IPinfo::IPinfoLite
    include IPinfoLite
    attr_accessor :access_token, :countries, :httpc

    def initialize(access_token = nil, settings = {})
        @access_token = access_token
        @httpc = IPinfo::AdapterLite.new(access_token, httpc || :net_http)

        maxsize = settings.fetch('maxsize', DEFAULT_CACHE_MAXSIZE)
        ttl = settings.fetch('ttl', DEFAULT_CACHE_TTL)
        @cache = settings.fetch('cache', IPinfo::DefaultCache.new(ttl, maxsize))
        @countries = settings.fetch('countries', DEFAULT_COUNTRY_LIST)
        @eu_countries = settings.fetch('eu_countries', DEFAULT_EU_COUNTRIES_LIST)
        @countries_flags = settings.fetch('countries_flags', DEFAULT_COUNTRIES_FLAG_LIST)
        @countries_currencies = settings.fetch('countries_currencies', DEFAULT_COUNTRIES_CURRENCIES_LIST)
        @continents = settings.fetch('continents', DEFAULT_CONTINENT_LIST)
    end

    def details(ip_address = nil)
        details_base(ip_address)
    end

    def request_details(ip_address = nil)
        if ip_address && ip_address != 'me' && isBogon(ip_address)
            details[:ip] = ip_address
            details[:bogon] = true
            details[:ip_address] = IPAddr.new(ip_address)

            return details
        end

        res = @cache.get(cache_key(ip_address))
        return res unless res.nil?

        ip_address ||= 'me'
        response = @httpc.get(escape_path(ip_address))

        if response.status.eql?(429)
            raise RateLimitError,
                  RATE_LIMIT_MESSAGE
        end

        details = JSON.parse(response.body, symbolize_names: true)
        @cache.set(cache_key(ip_address), details)
        details
    end

    def details_base(ip_address)
        details = request_details(ip_address)
        if details.key? :country_code
            details[:country_name] =
                @countries.fetch(details.fetch(:country_code), nil)
            details[:is_eu] =
                @eu_countries.include?(details.fetch(:country_code))
            details[:country_flag] =
                @countries_flags.fetch(details.fetch(:country_code), nil)
            details[:country_currency] =
                @countries_currencies.fetch(details.fetch(:country_code), nil)
            details[:continent] =
                @continents.fetch(details.fetch(:country_code), nil)
            details[:country_flag_url] = "#{COUNTRY_FLAGS_URL}#{details.fetch(:country_code)}.svg"
        end

        if details.key? :ip
            details[:ip_address] =
                IPAddr.new(details.fetch(:ip))
        end

        IPinfo::Response.new(details)
    end

    def isBogon(ip)
        if ip.nil?
          return false
        end

        matcher_object = IPinfo::IpAddressMatcher.new(ip)
        matcher_object.matches
    end

    def escape_path(ip)
        ip ? "/#{CGI.escape(ip)}" : '/'
    end

    def cache_key(ip)
        "1:#{ip}"
    end
end
