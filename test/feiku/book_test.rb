# frozen_string_literal: true

class TestFakerBook < Minitest::Test
  def setup
    @tester = Faker::Book
  end

  def test_title
    assert_match(/(\w+\.? ?){2,3}/, @tester.title)
  end

  def test_author
    assert_match(/(\w+\.? ?){2,3}/, @tester.author)
  end

  def test_publisher
    assert_match(/(\w+\.? ?){2,3}/, @tester.publisher)
  end

  def test_genre
    assert_match(/(\w+\.? ?){2,3}/, @tester.genre)
  end
end
