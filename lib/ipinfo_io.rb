# frozen_string_literal: true

require "ipinfo_io/version"
require 'ipinfo_io/errors'
require 'ipinfo_io/response'
require 'faraday'
require 'json'
require 'cgi'

module IpinfoIo
  RATE_LIMIT_MESSAGE = "To increase your limits, please review our paid plans at https://ipinfo.io/pricing"
  HOST = 'ipinfo.io'

  class << self
    attr_accessor :access_token

    def lookup(ip=nil)
      response = Faraday.get(url_builder(ip)) do |req|
        default_headers.each_pair do |key, value|
          req.headers[key] = value
        end
      end

      raise RateLimitError.new(RATE_LIMIT_MESSAGE) if response.status.eql?(429)

      IpinfoIo::Response.from_faraday(response)
    end

    private

    def url_builder(ip)
      if access_token
        "https://#{HOST}/#{ip}?token=#{CGI.escape(access_token)}"
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
