# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tienda_nube/version'

Gem::Specification.new do |spec|
  spec.name          = "tiendanube-ruby"
  spec.version       = TiendaNube::VERSION
  spec.authors       = ["Carlos Kozuszko"]
  spec.email         = ["carlos@insignia4u.com"]

  spec.summary       = %q{Simple gem to connect with the TiendaNube API.}
  spec.description   = %q{Simple gem to provida a basic connection with the TiendaNube API endpoints.}
  spec.homepage      = "https://github.com/boxupgo/tiendanube-ruby"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
end
