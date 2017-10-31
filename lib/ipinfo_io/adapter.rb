# frozen_string_literal: true
require 'faraday'

module IpinfoIo
  class Adapter
    HOST = 'ipinfo.io'

    def initialize(token=nil, conn=Faraday.new(url: "https://#{HOST}"))
      @token = token
      @conn = conn
    end

    def get(ip=nil)
      @conn.get(uri_builder(ip)) do |req|
        default_headers.each_pair do |key, value|
          req.headers[key] = value
        end
      end
    end

    private

    def uri_builder(ip)
      token ? "/#{ip}?token=#{token}" : "/#{ip}"
    end

    attr_reader :token

    def default_headers
        {
          'User-Agent' => "ruby/#{::IpinfoIo::VERSION}",
          'Accept' => 'application/json'
        }
    end
  end
end
