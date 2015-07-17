require "sinatra/base"
require "tilt/haml"
require "mime/types"

module Pixhibitee
  class App < Sinatra::Base
    set :public_folder, Proc.new { Dir.pwd }

    get "/*" do
      base_path = params["splat"][0]
      @paths = collect_image_files(base_path)
      @sub_directories = collect_sub_directories(base_path)
      haml :index
    end

    helpers do
      def collect_image_files(base_path)
        expanded_path = File.expand_path(base_path)
        if File.directory?(expanded_path)
          paths = Dir.glob("#{expanded_path}/*").select do |path|
            displayable?(path)
          end
          paths.map do |path|
            format_link(path, expanded_path, base_path)
          end
        else
          paths = [base_path]
        end
      end

      def collect_sub_directories(base_path)
        expanded_path = File.expand_path(base_path)
        if File.directory?(expanded_path)
          paths = Dir.glob("#{expanded_path}/*").select do |path|
            File.directory?(path)
          end
          paths.map do |path|
            format_link(path, expanded_path, base_path)
          end
        else
          []
        end
      end

      def displayable?(path)
        mime_type = MIME::Types.type_for(path)[0]
        return false unless mime_type
        return false if File.size(path) > 1_000_000
        mime_type.media_type == "image"
      end

      def format_link(path, expanded_path, base_path)
        src = "#{path.sub(expanded_path, base_path)}"
        src = "/#{src}" unless src.start_with?("/")
        src
      end
    end
  end
end
