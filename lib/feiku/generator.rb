# frozen_string_literal: true

module Feiku
  # Generator is a behind-scene class that generates fake data
  class Generator
    RANDOM_STRING = [*"a".."z", *"A".."Z"].freeze
    RANDOM_INTEGER = [*0..9].freeze
    def initialize(format:, value:, length:, pool_size: 0)
      @length = length
      @value = value
      @format, @size = if value.is_a?(Hash)
                         [format, value.size]
                       else
                         n = 0
                         format.gsub!(/%\{[^}]+\}/) { n += 1 and "%s" }
                         [format, n]
                       end
      @pool = pool_size.zero? ? nil : Array.new(pool_size) { _generate }
    end

    def generate
      @pool.nil? ? _generate : @pool.sample
    end

    def _generate
      @fillings = case @value
                  when :string, :integer
                    Array.new(@size) do
                      length = @length.is_a?(Integer) ? @length : @length.to_a.sample
                      self.class.const_get("RANDOM_#{@value.to_s.upcase}").sample(length).join
                    end
                  when Hash then @value.transform_values(&:sample)
                  else raise
                  end
      @format % @fillings
    end
  end
end
