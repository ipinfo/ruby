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
    RATE_LIMIT_MESSAGE = 'To increase your limits, please review our paid plans at https://ipinfo.io/pricing'

    class << self
        def create(access_token = nil, settings = {})
            IPinfo.new(access_token, settings)
        end
    end

    class IPinfo
        attr_accessor :access_token, :countries, :http_client

        def initialize(access_token = nil, settings = {})
            @access_token = access_token
            @http_client = http_client(settings.fetch('http_client', nil))

            maxsize = settings.fetch('maxsize', DEFAULT_CACHE_MAXSIZE)
            ttl = settings.fetch('ttl', DEFAULT_CACHE_TTL)
            @cache = settings.fetch('cache', DefaultCache.new(ttl, maxsize))
            @countries = countries(settings.fetch('countries',
                                                  DEFAULT_COUNTRY_FILE))
        end

        def details(ip_address = nil)
            details = request_details(ip_address)
            if details.has_key? :country
                details[:country_name] =
                    @countries.fetch(details.fetch(:country),
                                     nil)
            end

            if details.has_key? :ip
                details[:ip_address] =
                    IPAddr.new(details.fetch(:ip))
            end

            if details.has_key? :loc
                loc = details.fetch(:loc).split(',')
                details[:latitude] = loc[0]
                details[:longitude] = loc[1]
            end

            Response.new(details)
        end

        protected

        def request_details(ip_address = nil)
            unless @cache.contains?(ip_address)
                response = @http_client.get(escape_path(ip_address))

                if response.status.eql?(429)
                    raise RateLimitError,
                          RATE_LIMIT_MESSAGE
                end

                details = JSON.parse(response.body, symbolize_names: true)
                @cache.set(ip_address, details)
            end
            @cache.get(ip_address)
        end

        def http_client(http_client = nil)
            @http_client = if http_client
                               Adapter.new(access_token, http_client)
                           else
                               Adapter.new(access_token)
                           end
        end

        def countries(filename)
            file = File.read(filename)
            JSON.parse(file)
        end

        private

        def escape_path(ip)
            ip ? "/#{CGI.escape(ip)}" : '/'
        end
    end
end
