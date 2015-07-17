require "rack/test"

class AppTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    @app ||= Rack::Builder.parse_file("config.ru").first
  end

  def test_index
    get "/"
    assert_true(last_response.ok?)
  end
end
