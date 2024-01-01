# frozen_string_literal: true

require 'faraday'
require 'cgi'
require 'ipinfo/mod'
require_relative './version.rb'

class IPinfo::Adapter
    HOST = 'ipinfo.io'
    HOST_V6 = 'v6.ipinfo.io'

    attr_reader :conn

    def initialize(token = nil, adapter = :net_http, host_type = :v4)
        @token = token
        @host = (host_type == :v6) ? HOST_V6 : HOST
        @conn = connection(adapter)
    end

    def get(uri)
        @conn.get(uri) do |req|
            default_headers.each_pair do |key, value|
                req.headers[key] = value
            end
            req.params['token'] = CGI.escape(token) if token
        end
    end

    def post(uri, body, timeout = 2)
        @conn.post(uri) do |req|
            req.body = body
            req.options.timeout = timeout
        end
    end

    private

    attr_reader :token, :host

    def connection(adapter)
        Faraday.new(url: "https://#{@host}") do |conn|
            conn.adapter(adapter)
        end
    end

    def default_headers
        headers = {
            'User-Agent' => 'IPinfoClient/Ruby/#{IPinfo::VERSION}',
            'Accept' => 'application/json'
        }
        headers['Authorization'] = "Bearer #{CGI.escape(token)}" if token
        headers
    end
end
