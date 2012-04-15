# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.name          = "numerous_blocks"
  gem.authors       = ["Kim Burgestrand"]
  gem.email         = ["kim@burgestrand.se"]
  gem.summary       = "Numerous blocks helps you write Ruby methods that accept multiple blocks"
  gem.homepage      = "http://github.com/Burgestrand/numerous_blocks"

  gem.files         = `git ls-files`.split($\)
  gem.test_files    = 'numerous_blocks.rb'
  gem.require_paths = ["."]
  gem.version       = "1.0.0"
end
