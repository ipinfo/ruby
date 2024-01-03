# frozen_string_literal: true

require 'faraday'
require 'cgi'
require 'ipinfo/mod'
require_relative './version.rb'

class IPinfo::Adapter
    HOST = 'https://ipinfo.io'
    HOST_V6 = 'https://v6.ipinfo.io'

    attr_reader :conn

    def initialize(token = nil, adapter = :net_http)
        @token = token
        @conn = connection(adapter)
    end

    def get(uri, host_type= :v4)
        host = (host_type == :v6) ? HOST_V6 : HOST
        @conn.get(host + uri) do |req|
            default_headers.each_pair do |key, value|
                req.headers[key] = value
            end
            req.params['token'] = CGI.escape(token) if token
        end
    end

    def post(uri, body, timeout = 2)
        @conn.post(HOST + uri) do |req|
            req.body = body
            req.options.timeout = timeout
        end
    end

    private

    attr_reader :token

    def connection(adapter)
        Faraday.new() do |conn|
            conn.adapter(adapter)
        end
    end

    def default_headers
        headers = {
            'User-Agent' => "IPinfoClient/Ruby/#{IPinfo::VERSION}",
            'Accept' => 'application/json'
        }
        headers['Authorization'] = "Bearer #{CGI.escape(token)}" if token
        headers
    end
end
