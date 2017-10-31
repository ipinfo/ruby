# frozen_string_literal: true
require 'json'

module IpinfoIo
  class Response
    # The data contained by the HTTP body of the response deserialized from
    # JSON.
    attr_accessor :data

    # The raw HTTP body of the response.
    attr_accessor :body

    # A Hash of the HTTP headers of the response.
    attr_accessor :headers

    # The integer HTTP status code of the response.
    attr_accessor :status

    def self.from_faraday(response)
      resp = IpinfoIo::Response.new
      resp.data = JSON.parse(response.body, symbolize_names: true)
      resp.body = response.body
      resp.headers = response.headers
      resp.status = response.status
      resp
    end
  end
end
