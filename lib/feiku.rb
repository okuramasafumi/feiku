# frozen_string_literal: true

require_relative "feiku/version"
require_relative "feiku/generator"

# Toplevel
module Feiku
  class Error < StandardError; end

  def self.register(module_name, format:, value:, length: nil)
    const_set(module_name, Generator.new(format: format, value: value, length: length))
  end
end

Feiku.register(:Email, format: "%<name>ss@%<domain>s",
                       value: { name: %w[alice bob charlie], domain: %w[gmail.com yahoo.com] })
