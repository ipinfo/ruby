# frozen_string_literal: true
require 'faraday'

module IpinfoIo
  class Adapter
    HOST = 'ipinfo.io'

    def initialize(token=nil)
      @token = token
    end

    def get(ip=nil)
      Faraday.get(url_builder(ip)) do |req|
        default_headers.each_pair do |key, value|
          req.headers[key] = value
        end
      end
    end

    private

    attr_reader :token

    def url_builder(ip)
      if token
        "https://#{HOST}/#{ip}?token=#{token}"
      else
        "https://#{HOST}/#{ip}"
      end
    end

    def default_headers
        {
          'User-Agent' => "ruby/#{::IpinfoIo::VERSION}",
          'Accept' => 'application/json'
        }
    end
  end
end
