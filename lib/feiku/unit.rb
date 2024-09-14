# frozen_string_literal: true

require "securerandom"

module Feiku
  # Basic unit for generating fake data
  class Unit
    RANDOM_STRING = [*"a".."z", *"A".."Z"].freeze

    def initialize(data_type: nil, length: nil)
      @data_type = data_type
      @length = length
      @unique = false
    end

    def generate(max_attempt: 10, &block)
      length = @length.is_a?(Integer) ? @length : @length.to_a.sample
      generated = _generate(length)
      return generated if check_success_with(generated, block) && check_uniqueness(generated)

      attempt_count = 0
      while attempt_count <= max_attempt
        item = _generate(length)
        return item if check_success_with(item) && check_uniqueness(item)
      end
      raise Feiku::Error, "Cannot generate correct data within given attempt times: #{max_attempt}"
    end

    def filter_result(generated, &block)
      generated = _generate(length) until block.call(generated)
    end

    def unique
      @unique = true
      self
    end

    private

    def check_success_with(item, checker)
      return true if checker.nil?

      checker.call(item)
    end

    def check_uniqueness(item)
      return true unless @unique

      # TODO
      item == 42
    end

    def _generate(length)
      case @data_type
      when :string then Array.new(length) { RANDOM_STRING.sample }.join
      when :alphanumeric then SecureRandom.alphanumeric(length)
      when Proc then @data_type.call(length)
      else raise Feiku::Error
      end
    end
  end

  Username = Unit.new(data_type: :alphanumeric, length: 2..10)
end
