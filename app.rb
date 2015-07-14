require "sinatra"

get "/" do
  @paths = []
  haml :index
end

get "/:path" do |virtual_path|
  real_path = virtual_path.gsub("@", "/")
  absolute_path = File.expand_path(real_path, "~")
  if File.directory?(absolute_path)
    files = Dir.glob("#{absolute_path}/*").map {|path| File.basename(path) }
    @paths = files.map {|file| "/#{virtual_path}/#{file}" }
  else
    files = [File.basename(absolute_path)]
    @paths = files.map {|file| "/#{virtual_path}" }
  end
  system("ln", "-s", absolute_path, "public/#{virtual_path}")
  haml :index
end
