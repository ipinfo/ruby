# frozen_string_literal: true

require "ipinfo_io/version"
require 'ipinfo_io/errors'
require 'faraday'
require 'json'

module IpinfoIo
  RATE_LIMIT_MESSAGE = "To increase your limits, please review our paid plans at https://ipinfo.io/pricing"
  HOST = 'ipinfo.io'

  class << self
    attr_writer :access_token

    def lookup(ip=nil)
      response = Faraday.get("https://#{HOST}/#{ip}") do |req|
        default_headers.each_pair do |key, value|
          req.headers[key] = value
        end
        req.headers['Authorization'] = "Bearer #{@access_token}" if @access_token
      end

      raise RateLimitError.new(RATE_LIMIT_MESSAGE) if response.status.eql?(429)

      JSON.parse(response.body)
    end

    private

    def default_headers
        {
          'User-Agent' => "ruby/#{::IpinfoIo::VERSION}",
          'Accept' => 'application/json'
        }
    end
  end
end
