# frozen_string_literal: true

using(Module.new do
  refine Array do
    alias_method :generate, :sample
  end
end)

module Feiku
  # Generator is a behind-scene class that generates fake data
  class Generator
    RANDOM_STRING = [*"a".."z", *"A".."Z"].freeze
    RANDOM_INTEGER = [*0..9].freeze
    def initialize(format:, value:, length:, pool_size: 0, &block) # rubocop:disable Metrics/MethodLength
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
      self.class.class_eval(&block) if block_given?
    end

    def generate
      @pool.nil? ? _generate : @pool.sample
    end

    private

    def _generate
      @fillings = case @value
                  when :string, :integer
                    Array.new(@size) do
                      length = @length.is_a?(Integer) ? @length : @length.to_a.sample
                      self.class.const_get("RANDOM_#{@value.to_s.upcase}").sample(length).join
                    end
                  when Hash then @value.transform_values(&:generate)
                  else raise
                  end
      @format % @fillings
    end
  end
end
