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
      paths = Dir.glob("#{absolute_path}/*").select {|path|
        displayable?(path)
      }.map {|path| File.basename(path) }
      paths.map {|file| "/#{virtual_path}/#{file}" }
    else
      paths = [File.basename(absolute_path)]
      paths.map {|file| "/#{virtual_path}" }
    end
  end

  def displayable?(path)
    mime_type = MIME::Types.type_for(path)[0]
    return false unless mime_type
    return false if File.size(path) > 1_000_000
    mime_type.media_type == "image"
  end
end
