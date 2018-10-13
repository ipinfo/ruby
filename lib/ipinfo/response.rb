# frozen_string_literal: true

require 'ipaddr'
require 'json'

module IPinfo
  class Response

    attr_reader :all

    def initialize(response)
      @all = response

      @all.each do |name, value|
        instance_variable_set("@#{name}", value)
        self.class.send(:attr_accessor, name)
      end
    end
  end
end
