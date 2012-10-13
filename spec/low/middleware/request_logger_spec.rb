require File.dirname(__FILE__) + '/../../spec_helper'
require 'logger'

describe Low::Middleware::RequestLogger do
  describe '.level' do
    it 'should return Logger::FATAL if the LOG_LEVEL evironment var is \'FATAL\'' do
      ENV['LOG_LEVEL'] = 'FATAL'
      Low::Middleware::RequestLogger.level.should == Logger::FATAL
    end

    it 'should return Logger::ERROR if the LOG_LEVEL evironment var is \'ERROR\'' do
      ENV['LOG_LEVEL'] = 'ERROR'
      Low::Middleware::RequestLogger.level.should == Logger::ERROR
    end

    it 'should return Logger::WARN if the LOG_LEVEL evironment var is \'WARN\'' do
      ENV['LOG_LEVEL'] = 'WARN'
      Low::Middleware::RequestLogger.level.should == Logger::WARN
    end

    it 'should return Logger::INFO if the LOG_LEVEL evironment var is \'INFO\'' do
      ENV['LOG_LEVEL'] = 'INFO'
      Low::Middleware::RequestLogger.level.should == Logger::INFO
    end

    it 'should return Logger::DEBUG if the LOG_LEVEL evironment var is \'DEBUG\'' do
      ENV['LOG_LEVEL'] = 'DEBUG'
      Low::Middleware::RequestLogger.level.should == Logger::DEBUG
    end

    it 'should return Logger::INFO if the LOG_LEVEL evironment var is not set' do
      ENV['LOG_LEVEL'] = nil
      Low::Middleware::RequestLogger.level.should == Logger::INFO
    end
  end
end
