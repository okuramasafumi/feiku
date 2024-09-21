# frozen_string_literal: true

class UnitTest < Minitest::Test
  def test_string
    unit1 = Feiku::Unit.new(data_type: :string, length: 1)
    unit2 = Feiku::Unit.new(data_type: :string, length: 2)
    unit_range = Feiku::Unit.new(data_type: :string, length: 1..10)
    (ENV["FEIKU_TEST_ATTEMPT"] || 100).to_i.times do
      assert_match(/[a-zA-Z]/, unit1.generate)
      assert_match(/[a-zA-Z]{2}/, unit2.generate)
      assert_match(/[a-zA-Z]{1,10}/, unit_range.generate)
      refute_match(/[0-9]/, unit_range.generate)
    end
  end

  def test_unique_string
    unit1 = Feiku::Unit.new(data_type: :string, length: 1).unique
    unit2 = Feiku::Unit.new(data_type: :string, length: 2).unique
    unit_range = Feiku::Unit.new(data_type: :string, length: 1..10).unique
    chars1 = Array.new(52) { unit1.generate }
    assert_equal chars1, chars1.uniq
    chars2 = Array.new(52 ^ 2) { unit2.generate }
    assert_equal chars2, chars2.uniq
    chars3 = Array.new(52 ^ 10) { unit_range.generate }
    assert_equal chars3, chars3.uniq
  end

  def test_alphanumeric
    unit1 = Feiku::Unit.new(data_type: :alphanumeric, length: 1)
    unit2 = Feiku::Unit.new(data_type: :alphanumeric, length: 2)
    unit_range = Feiku::Unit.new(data_type: :alphanumeric, length: 1..10)
    (ENV["FEIKU_TEST_ATTEMPT"] || 100).to_i.times do
      assert_match(/[a-zA-Z0-9]/, unit1.generate)
      assert_match(/[a-zA-Z0-9]{2}/, unit2.generate)
      assert_match(/[a-zA-Z0-9]{1,10}/, unit_range.generate)
    end
  end
end
