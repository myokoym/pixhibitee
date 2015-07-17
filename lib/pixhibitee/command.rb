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
    option :public, :type => :boolean, :desc => "Publish to network"
    option :port, :type => :string, :desc => "Set port number"
    def start
      web_server_thread = Thread.new do
        if options[:public]
          start_public_server
        else
          start_private_server
        end
      end
      Launchy.open("http://localhost:#{port}") unless options[:silent]
      web_server_thread.join
    end

    private
    def port
      options[:port] || "4567"
    end

    def start_private_server
      Pixhibitee::App.run!
    end

    def start_public_server
      Rack::Server.start({
        :config => File.join(File.dirname(__FILE__), "../../config.ru"),
        :Host   => "0.0.0.0",
        :Port   => port,
      })
    end
  end
end
