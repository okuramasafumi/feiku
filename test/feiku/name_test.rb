# frozen_string_literal: true

class NameTest < Minitest::Test
  def setup
    @tester = Faker::Name
  end

  # Copied from Faker
  def test_name
    assert_match(/(\w+\.? ?){2,3}/, @tester.name)
  end

  def test_name_with_middle
    assert_match(/(\w+\.? ?){3,4}/, @tester.name_with_middle)
  end

  def test_first_name
    assert_match(/(\w+\.? ?){2,4}/, @tester.first_name)
  end

  def test_middle_name
    assert_match(/(\w+\.? ?){3,4}/, @tester.middle_name)
  end

  def test_last_name
    assert_match(/(\w+\.? ?){3,4}/, @tester.last_name)
  end
end
