require "thor"
require "launchy"
require "pixhibitee"

module Pixhibitee
  class Command < Thor
    default_command :start

    map "-v" => :version

    desc "version", "Show version number."
    def version
      puts Pixhibitee::VERSION
    end

    desc "start", "Start web server."
    option :silent, :type => :boolean, :desc => "Don't open in browser"
    def start
      web_server_thread = Thread.new { Pixhibitee::App.run! }
      Launchy.open("http://localhost:4567") unless options[:silent]
      web_server_thread.join
    end
  end
end
