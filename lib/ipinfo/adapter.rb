# frozen_string_literal: true
require 'faraday'
require 'cgi'

module IPinfo
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
      Faraday.new(url: "https://#{HOST}") do |faraday|
        faraday.adapter adapter
      end
    end

    def default_headers
        headers = {
          'User-Agent' => "IPinfoClient/Ruby/1.0",
          'Accept' => 'application/json'
        }
        if token
          headers['Authorization'] = "Bearer #{CGI::escape(token)}"
        end
        puts headers
        headers
    end
  end
end
