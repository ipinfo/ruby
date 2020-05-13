# frozen_string_literal: true
require 'pry'

require 'ipaddr'
require 'json'

module IPinfo
  class Response

    attr_reader :all

    def initialize(response)
      @all = response

      @all.each do |name, value|
        instance_variable_set("@#{name}", value)
        unless self.respond_to?(name)
          self.class.send(:attr_accessor, name)
        end
      end
    end
  end
end
