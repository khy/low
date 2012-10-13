require File.dirname(__FILE__) + '/../../spec_helper'
require 'logger'

describe Low::Middleware::LogLevel do
  def test_app
    lambda do |env|
      [200, {'Content-Type' => 'text/plain'}, env['low.log_level']]
    end
  end

  before(:all) { @original_log_level = ENV['LOG_LEVEL'] }
  after(:each) { ENV['LOG_LEVEL'] = @original_log_level }

  it 'should set low.log_level to `Logger::FATAL` if LOG_LEVEL is \'FATAL\'' do
    ENV['LOG_LEVEL'] = 'FATAL'
    rack = Low::Middleware::LogLevel.new test_app
    response = rack.call({})
    response[2].should == Logger::FATAL
  end

  it 'should set low.log_level to `Logger::ERROR` if LOG_LEVEL is \'ERROR\'' do
    ENV['LOG_LEVEL'] = 'ERROR'
    rack = Low::Middleware::LogLevel.new test_app
    response = rack.call({})
    response[2].should == Logger::ERROR
  end

  it 'should set low.log_level to `Logger::WARN` if LOG_LEVEL is \'WARN\'' do
    ENV['LOG_LEVEL'] = 'WARN'
    rack = Low::Middleware::LogLevel.new test_app
    response = rack.call({})
    response[2].should == Logger::WARN
  end

  it 'should set low.log_level to `Logger::INFO` if LOG_LEVEL is \'INFO\'' do
    ENV['LOG_LEVEL'] = 'INFO'
    rack = Low::Middleware::LogLevel.new test_app
    response = rack.call({})
    response[2].should == Logger::INFO
  end

  it 'should set low.log_level to `Logger::DEBUG` if LOG_LEVEL is \'DEBUG\'' do
    ENV['LOG_LEVEL'] = 'DEBUG'
    rack = Low::Middleware::LogLevel.new test_app
    response = rack.call({})
    response[2].should == Logger::DEBUG
  end

  it 'should set low.log_level to `Logger::INFO` if neither LOG_LEVEL nor `:default_level` is set' do
    ENV['LOG_LEVEL'] = nil
    rack = Low::Middleware::LogLevel.new test_app
    response = rack.call({})
    response[2].should == Logger::INFO
  end

  it 'should set low.log_level to the specified `:default_level` if LOG_LEVEL is not set' do
    ENV['LOG_LEVEL'] = nil
    rack = Low::Middleware::LogLevel.new test_app, default_level: Logger::DEBUG
    response = rack.call({})
    response[2].should == Logger::DEBUG
  end
end
