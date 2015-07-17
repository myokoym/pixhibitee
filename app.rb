require "sinatra"
require "mime/types"

get "/" do
  absolute_path = File.expand_path("..", __FILE__)
  @paths = collect_image_files(absolute_path, "@")
  system("ln", "-sfn", absolute_path, "public/@")
  haml :index
end

get "/:path" do |virtual_path|
  real_path = virtual_path.gsub("@", "/")
  absolute_path = File.expand_path(real_path, "~")
  @paths = collect_image_files(absolute_path, virtual_path)
  system("ln", "-sfn", absolute_path, "public/#{virtual_path}")
  haml :index
end

helpers do
  def collect_image_files(absolute_path, virtual_path)
    if File.directory?(absolute_path)
      files = Dir.glob("#{absolute_path}/*").map {|path| File.basename(path) }.select do |path|
        displayable?(path)
      end
      files.map {|file| "/#{virtual_path}/#{file}" }
    else
      files = [File.basename(absolute_path)]
      files.map {|file| "/#{virtual_path}" }
    end
  end

  def displayable?(path)
    mime_type = MIME::Types.type_for(path)[0]
    return false unless mime_type
    mime_type.media_type == "image"
  end
end
