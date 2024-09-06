# frozen_string_literal: true

require_relative "feiku/version"
require_relative "feiku/generator"

# Toplevel
module Feiku
  class Error < StandardError; end

  def self.register(module_name, format:, value:, length: nil, pool_size: 0)
    const_set(module_name, Generator.new(format: format, value: value, length: length, pool_size: pool_size))
  end
end

Feiku.register(:Email, format: "%<name>ss@%<domain>s",
                       value: { name: %w[alice bob charlie], domain: %w[a.example.invalid b.example.invalid] })
