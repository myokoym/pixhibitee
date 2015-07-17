require "fileutils"
require "stringio"
require "pixhibitee/version"
require "pixhibitee/command"

class CommandTest < Test::Unit::TestCase
  def setup
    @command = Pixhibitee::Command.new
  end

  def test_version
    s = ""
    io = StringIO.new(s)
    $stdout = io
    @command.version
    assert_equal("#{Pixhibitee::VERSION}\n", s)
    $stdout = STDOUT
  end
end
