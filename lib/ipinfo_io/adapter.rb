# frozen_string_literal: true
require 'faraday'
require 'cgi'

module IpinfoIo
  class Adapter
    HOST = 'ipinfo.io'

    attr_reader :conn

    def initialize(token = nil, adapter = :net_http)
      @token = token
      @conn = connection(adapter)
    end

    def get(uri)
      @conn.get(uri) do |req|
        default_headers.each_pair do |key, value|
          req.headers[key] = value
        end
        req.params['token'] = CGI::escape(token) if token
      end
    end

    private

    attr_reader :token

    def connection(adapter)
      Faraday.new(url: host) do |faraday|
        faraday.adapter adapter
      end
    end

    def host
      "https://#{HOST}"
    end

    def default_headers
        {
          'User-Agent' => "ruby/#{::IpinfoIo::VERSION}",
          'Accept' => 'application/json'
        }
    end
  end
end
