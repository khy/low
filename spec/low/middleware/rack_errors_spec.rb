require File.dirname(__FILE__) + '/../../spec_helper'
require 'fileutils'

describe Low::Middleware::RackErrors do
  def test_app
    lambda do |env|
      [200, {'Content-Type' => 'text/plain'}, env['rack.errors']]
    end
  end

  after(:each) do
    ENV['RACK_ENV'] = 'test'
  end

  it 'should log to the FS in the development RACK_ENV by default' do
    ENV['RACK_ENV'] = 'development'
    rack = Low::Middleware::RackErrors.new test_app
    response = rack.call({})
    response[2].path.should == 'log/development.log'
  end

  it 'should log to the FS in the test RACK_ENV by default' do
    ENV['RACK_ENV'] = 'test'
    rack = Low::Middleware::RackErrors.new test_app
    response = rack.call({})
    response[2].path.should == 'log/test.log'
  end

  it 'should log to the FS in the specified RACK_ENV' do
    ENV['RACK_ENV'] = 'production'
    rack = Low::Middleware::RackErrors.new test_app, fs_envs: ['production']
    response = rack.call({})
    response[2].path.should == 'log/production.log'
  end

  it 'should log to STDOUT if not in a specified RACK_ENV' do
    ENV['RACK_ENV'] = 'production'
    rack = Low::Middleware::RackErrors.new test_app
    response = rack.call({})
    response[2].should == STDOUT
  end
end
