# frozen_string_literal: true

require_relative "feiku/version"
require_relative "feiku/generator"
require_relative "feiku/unit"
require_relative "feiku/faker_compat"

# Toplevel
module Feiku
  RANDOM_STRING = [*"a".."z", *"A".."Z"].freeze
  public_constant :RANDOM_STRING

  RANDOM_INTEGER = Array(0..9).freeze
  public_constant :RANDOM_INTEGER

  @faker_compat_registry = {}

  class Error < StandardError; end

  # Primary interface to add fake data definition
  def self.register(module_name, format:, value:, length: nil, pool_size: 0, faker_compat: nil) # rubocop:disable Metrics/ParameterLists
    generator = Generator.new(format: format, value: value, length: length, pool_size: pool_size)
    @faker_compat_registry.update(faker_compat => generator) if faker_compat
    remove_const(module_name) if const_defined?(module_name)
    const_set(module_name, generator)
  end

  # An interface for Faker compatibility
  def self.lookup(module_name, method_name, &block)
    @faker_compat_registry.fetch("#{module_name}.#{method_name}", &block)
  end

  register(:Default, format: "%<name>s", value: { name: Unit::Username })
  register(
    :Name,
    format: "%<first_name>s %<last_name>s",
    value: { first_name: Unit::Firstname, last_name: Unit::Lastname },
    faker_compat: "Name.name"
  )
  register(:Firstname, format: "%<name>s", value: { name: Unit::Firstname }, faker_compat: "Name.first_name")
  register(:Middlename, format: "%<name>s", value: { name: Unit::Firstname }, faker_compat: "Name.middle_name")
  register(:Lastname, format: "%<name>s", value: { name: Unit::Firstname }, faker_compat: "Name.last_name")
  register(
    :NameWithMiddle,
    format: "%<first_name>s %<middle_name>s %<last_name>s",
    value: {
      first_name: Unit::Firstname,
      middle_name: Unit::Firstname,
      last_name: Unit::Lastname
    },
    faker_compat: "Name.name_with_middle"
  )
  register(:Domain, format: "%<name>s.example", value: { name: Unit::Username })
  register(
    :Email,
    format: "%<name>s@%<domain>s",
    value: { name: Unit::Username, domain: Domain },
    faker_compat: "Internet.email"
  )
end
