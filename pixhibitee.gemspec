# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pixhibitee/version'

Gem::Specification.new do |spec|
  spec.name          = "pixhibitee"
  spec.version       = Pixhibitee::VERSION
  spec.authors       = ["Masafumi Yokoyama"]
  spec.email         = ["myokoym@gmail.com"]

  spec.description   = %q{An image viewer as a web application for local files. You can open your pictures exhibition easily on web.}
  spec.summary       = %q{Image viewer as a web application}
  spec.homepage      = "https://github.com/myokoym/pixhibitee"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) {|f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency("sinatra")
  spec.add_runtime_dependency("haml")
  spec.add_runtime_dependency("mime-types")
  spec.add_runtime_dependency("thor")

  spec.add_development_dependency("test-unit")
  spec.add_development_dependency("bundler")
  spec.add_development_dependency("rake")
end
