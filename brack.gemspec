# -*- encoding: utf-8 -*-
require File.expand_path('../lib/brack/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ['Kevin Hyland']
  gem.email         = ['khy@me.com']
  gem.description   = 'A Rack stack named brack'
  gem.summary       = 'A collection of racks that I\'m partial towards.'
  gem.homepage      = ''

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = 'brack'
  gem.require_paths = ['lib']
  gem.version       = Brack::VERSION

  gem.add_runtime_dependency 'rack'

  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'rack-test'
end
