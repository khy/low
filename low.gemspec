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

  gem.add_runtime_dependency 'rack',          '~> 1.5.2'
  gem.add_runtime_dependency 'mongo',         '~> 1.8.2'
  gem.add_runtime_dependency 'bson_ext',      '~> 1.8.2'

  gem.add_development_dependency 'rspec',     '~> 2.12.0'
  gem.add_development_dependency 'rack-test', '~> 0.6.2'
end
