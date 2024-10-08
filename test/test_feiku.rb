# frozen_string_literal: true

require "test_helper"

class TestFeiku < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Feiku::VERSION
  end

  def test_double_register
    Feiku.register :TestDoubleRegister, format: "", value: :string
    assert_silent { Feiku.register :TestDoubleRegister, format: "", value: :string }
  end
end
