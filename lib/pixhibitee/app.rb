require "sinatra/base"
require "tilt/haml"
require "mime/types"

module Pixhibitee
  class App < Sinatra::Base
    set :public_folder, Proc.new { Dir.pwd }

    get "/*" do
      base_path = params["splat"][0]
      @paths = collect_image_files(base_path)
      haml :index
    end

    helpers do
      def collect_image_files(base_path)
        expanded_path = File.expand_path(base_path)
        if File.directory?(expanded_path)
          paths = Dir.glob("#{expanded_path}/*").select {|path|
            displayable?(path)
          }
          paths.map do |path|
            src = "#{path.sub(expanded_path, base_path)}"
            src = "/#{src}" unless src.start_with?("/")
            src
          end
        else
          paths = [base_path]
        end
      end

      def displayable?(path)
        mime_type = MIME::Types.type_for(path)[0]
        return false unless mime_type
        return false if File.size(path) > 1_000_000
        mime_type.media_type == "image"
      end
    end
  end
end
