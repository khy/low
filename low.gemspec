# -*- encoding: utf-8 -*-
require File.expand_path('../lib/low/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ['Kevin Hyland']
  gem.email         = ['khy@me.com']
  gem.description   = 'A low-level utility library.'
  gem.summary       = 'A low-level utility library.'
  gem.homepage      = ''

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = 'low'
  gem.require_paths = ['lib']
  gem.version       = Low::VERSION

  gem.add_runtime_dependency 'rack'

  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'rack-test'
  gem.add_development_dependency 'mongo'
  gem.add_development_dependency 'bson_ext'
end
