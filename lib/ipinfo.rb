# frozen_string_literal: true

require 'cgi'
require 'ipaddr'
require 'ipinfo/adapter'
require 'ipinfo/cache/default_cache'
require 'ipinfo/errors'
require 'ipinfo/response'
require 'ipinfo/version'
require 'json'

module IPinfo
    DEFAULT_CACHE_MAXSIZE = 4096
    DEFAULT_CACHE_TTL = 60 * 60 * 24
    DEFAULT_COUNTRY_FILE = File.join(File.dirname(__FILE__),
                                     'ipinfo/countries.json')
    DEFAULT_EU_COUNTRY_FILE = File.join(File.dirname(__FILE__),
                                     'ipinfo/eu.json')
    RATE_LIMIT_MESSAGE = 'To increase your limits, please review our ' \
                         'paid plans at https://ipinfo.io/pricing'

    class << self
        def create(access_token = nil, settings = {})
            IPinfo.new(access_token, settings)
        end
    end
end

class IPinfo::IPinfo
    include IPinfo
    attr_accessor :access_token, :countries, :httpc

    def initialize(access_token = nil, settings = {})
        @access_token = access_token
        @httpc = prepare_http_client(settings.fetch('http_client', nil))

        maxsize = settings.fetch('maxsize', DEFAULT_CACHE_MAXSIZE)
        ttl = settings.fetch('ttl', DEFAULT_CACHE_TTL)
        @cache = settings.fetch('cache', DefaultCache.new(ttl, maxsize))
        @countries = prepare_json(settings.fetch('countries',
                                                      DEFAULT_COUNTRY_FILE))
        @eucountries = prepare_json(settings.fetch('eucountries',
                                                      DEFAULT_EU_COUNTRY_FILE))
    end

    def details(ip_address = nil)
        details = request_details(ip_address)
        if details.key? :country
            details[:country_name] =
                @countries.fetch(details.fetch(:country), nil)
            details[:is_eu] =
                @eucountries.include?(details.fetch(:country))
        end

        if details.key? :ip
            details[:ip_address] =
                IPAddr.new(details.fetch(:ip))
        end

        if details.key? :loc
            loc = details.fetch(:loc).split(',')
            details[:latitude] = loc[0]
            details[:longitude] = loc[1]
        end

        Response.new(details)
    end

    protected

    def request_details(ip_address = nil)
        res = @cache.get(ip_address)
        return res unless res.nil?

        response = @httpc.get(escape_path(ip_address))

        if response.status.eql?(429)
            raise RateLimitError,
                  RATE_LIMIT_MESSAGE
        end

        details = JSON.parse(response.body, symbolize_names: true)
        @cache.set(ip_address, details)
        details
    end

    def prepare_http_client(httpc = nil)
        @httpc = if httpc
                     Adapter.new(access_token, httpc)
                 else
                     Adapter.new(access_token)
                 end
    end

    def prepare_json(filename)
        file = File.read(filename)
        JSON.parse(file)
    end

    private

    def escape_path(ip)
        ip ? "/#{CGI.escape(ip)}" : '/'
    end
end
