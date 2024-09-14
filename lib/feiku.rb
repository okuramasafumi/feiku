# frozen_string_literal: true

require_relative "feiku/version"
require_relative "feiku/generator"
require_relative "feiku/unit"

# Toplevel
module Feiku
  class Error < StandardError; end

  def self.register(module_name, format:, value:, length: nil, pool_size: 0)
    const_set(module_name, Generator.new(format: format, value: value, length: length, pool_size: pool_size))
  end
end

Feiku.register(:Domain, format: "%<name>s.example", value: { name: Feiku::Username })
Feiku.register(:Email,
               format: "%<name>s@%<domain>s",
               value: { name: Feiku::Username, domain: Feiku::Domain })
