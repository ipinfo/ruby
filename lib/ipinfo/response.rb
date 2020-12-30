# frozen_string_literal: true

require 'ipaddr'
require 'json'

class IPinfo::Response
    attr_reader :all

    def initialize(response)
        @all = response

        @all.each do |name, value|
            instance_variable_set("@#{name}", value)

            c = class << self; self end
            c.send(:attr_accessor, name)
        end
    end
end
