# frozen_string_literal: true

require "ipinfo_io/version"
require 'ipinfo_io/errors'
require 'faraday'
require 'json'

module IpinfoIo
  RATE_LIMIT_MESSAGE = "To increase your limits, please review our paid plans at https://ipinfo.io/pricing"

  class << self
    def lookup(ip=nil)
      response = Faraday.get("https://ipinfo.io/#{ip}") do |req|
        default_header.each_pair do |key, value|
          req.headers[key] = value
        end
      end

      raise RateLimitError.new(RATE_LIMIT_MESSAGE) if response.status.eql?(429)

      JSON.parse(response.body)
    end


    private

    def default_header
        {
          'User-Agent' => "ruby/#{::IpinfoIo::VERSION}",
          'Accept' => 'application/json'
        }
    end
  end
end
