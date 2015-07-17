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
        collect_files(base_path) do |path|
          displayable?(path)
        end
      end

      def collect_sub_directories(base_path)
        collect_files(base_path) do |path|
          File.directory?(path)
        end
      end

      def collect_files(base_path)
        expanded_path = File.expand_path(base_path)
        paths = Dir.glob("#{expanded_path}/*").select do |path|
          yield(path)
        end
        paths.map do |path|
          format_link(path, expanded_path, base_path)
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
