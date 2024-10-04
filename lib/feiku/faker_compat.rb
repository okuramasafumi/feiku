# frozen_string_literal: true

module Feiku
  # MetaProxy is a class just for const_missing
  class MetaProxy
    def self.const_missing(name)
      Proxy.new(name)
    end
  end

  # Proxy is a simple blank object to invoke method_missing
  class Proxy < BasicObject
    def initialize(name)
      @name = name
    end

    private

    def method_missing(meth)
      generator = ::Feiku.lookup(@name, meth)
      raise ArgumentError, "No generator found for #{@name}.#{meth}" unless generator

      generator.generate
    end

    def respond_to_missing?(meth)
      !!::Feiku.lookup(@name, meth)
    end
  end
end

Faker = Feiku::MetaProxy
