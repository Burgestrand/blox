# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.name          = "blox"
  gem.authors       = ["Kim Burgestrand"]
  gem.email         = ["kim@burgestrand.se"]
  gem.summary       = "Blox helps you write Ruby methods that accept multiple blocks"
  gem.homepage      = "https://github.com/Burgestrand/blox"

  gem.files         = `git ls-files`.split($\)
  gem.test_files    = 'blox.rb'
  gem.require_paths = ["."]
  gem.version       = "1.0.0"
end
