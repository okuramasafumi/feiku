# frozen_string_literal: true

require_relative "feiku/version"
require_relative "feiku/generator"
require_relative "feiku/unit"
require_relative "feiku/faker_compat"

# Toplevel
module Feiku
  @faker_compat_registry = {}

  class Error < StandardError; end

  # Primary interface to add fake data definition
  def self.register(module_name, format:, value:, length: nil, pool_size: 0, faker_compat: nil) # rubocop:disable Metrics/ParameterLists
    generator = Generator.new(format: format, value: value, length: length, pool_size: pool_size)
    @faker_compat_registry.update(faker_compat => generator) if faker_compat
    const_set(module_name, generator)
  end

  # An interface for Faker compatibility
  def self.lookup(module_name, method_name)
    @faker_compat_registry.fetch("#{module_name}.#{method_name}")
  end
end

Feiku.register(:Name, format: "%<first_name>s %<last_name>s",
                      value: { first_name: Feiku::Firstname, last_name: Feiku::Lastname },
                      faker_compat: "Name.name")
Feiku.register(:NameWithMiddle, format: "%<first_name>s %<middle_name>s %<last_name>s",
                                value: {
                                  first_name: Feiku::Firstname,
                                  middle_name: Feiku::Firstname,
                                  last_name: Feiku::Lastname
                                },
                                faker_compat: "Name.name_with_middle")
Feiku.register(:Domain, format: "%<name>s.example", value: { name: Feiku::Username })
Feiku.register(:Email,
               format: "%<name>s@%<domain>s",
               value: { name: Feiku::Username, domain: Feiku::Domain })
