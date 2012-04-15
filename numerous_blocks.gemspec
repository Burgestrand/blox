# -*- encoding: utf-8 -*-
require File.expand_path('./version', File.dirname(__FILE__))

Gem::Specification.new do |gem|
  gem.name          = "Numerous blocks"
  gem.authors       = ["Kim Burgestrand"]
  gem.email         = ["kim@burgestrand.se"]
  gem.summary       = "Numerous blocks helps you write Ruby methods that accept multiple blocks"
  gem.homepage      = "http://github.com/Burgestrand/numerous_blocks"

  gem.files         = `git ls-files`.split($\)
  gem.test_files    = 'numerous_blocks_spec.rb'
  gem.require_paths = ["."]
  gem.version       = NumerousBlocks::VERSION
end
