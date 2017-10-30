# frozen_string_literal: true

require "ipinfo_io/version"
require 'faraday'
require 'json'

module IpinfoIo
  class << self
    def lookup(ip=nil)
      response = Faraday.get("https://ipinfo.io/#{ip}") do |req|
        default_header.each_pair do |key, value|
          req.headers[key] = value
        end
      end

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
