# frozen_string_literal: true

require "ipinfo_io/version"
require 'ipinfo_io/errors'
require 'ipinfo_io/response'
require 'ipinfo_io/adapter'
require 'cgi'

module IpinfoIo
  RATE_LIMIT_MESSAGE = "To increase your limits, please review our paid plans at https://ipinfo.io/pricing"

  class << self
    attr_accessor :access_token
    attr_writer :http_adapter

    def lookup(ip=nil)
      response = if @http_adapter
        Adapter.new(access_token, @http_adapter)
      else
        Adapter.new(access_token)
      end.get(uri_builder(ip))

      raise RateLimitError.new(RATE_LIMIT_MESSAGE) if response.status.eql?(429)

      Response.from_faraday(response)
    end

    private

    def uri_builder(ip)
      ip ? "/#{CGI::escape(ip)}" : '/'
    end
  end
end
