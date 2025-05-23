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
      @uniqueness_pool = []
    end

    def generate(max_attempt: 1000, &block)
      length = @length.is_a?(Integer) ? @length : @length.to_a.sample
      generated = _generate(length)
      if check_success_with(generated, block) && check_uniqueness(generated)
        @uniqueness_pool << generated
        return generated
      end

      try_until_success(length, max_attempt, &block)
    end

    def try_until_success(length, max_attempt, &block)
      attempt_count = 0
      while attempt_count <= max_attempt
        item = _generate(length)
        if check_success_with(item, block) && check_uniqueness(item)
          @uniqueness_pool << item
          return item
        end

        attempt_count += 1
      end
      raise Feiku::Error, "Cannot generate correct data within given attempt times: #{max_attempt}"
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

      @uniqueness_pool.none? { |pool_item| pool_item == item }
    end

    def _generate(length)
      case @data_type
      when :string then Array.new(length) { RANDOM_STRING.sample }.join
      when :alphanumeric then SecureRandom.alphanumeric(length)
      when Proc then @data_type.call(length)
      else raise Feiku::Error
      end
    end

    # rubocop:disable Lint/UselessConstantScoping
    Username = Unit.new(data_type: :alphanumeric, length: 2..10)
    Firstname = Unit.new(data_type: ->(l) { Feiku::Unit::RANDOM_STRING.sample(l).join.capitalize }, length: 3..8)
    Lastname = Firstname
    # rubocop:enable Lint/UselessConstantScoping
  end
end
