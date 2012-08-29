ENV['RACK_ENV'] = 'test'
require File.dirname(__FILE__) + '/../lib/low'

require 'rack/mock'
require 'rack/test'

RSpec.configure do |config|
  config.order = :rand
end
