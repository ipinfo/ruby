require "ipinfo_io/version"
require 'faraday'
require 'json'
require 'pry'

module IpinfoIo
	def self.call
    response = Faraday.get('https://ipinfo.io') do |req|
      req.headers['User-Agent'] = 'curl/7.30.0'
    end

    JSON.parse(response.body)
	end
end
