require File.dirname(__FILE__) + '/../../spec_helper'
require 'logger'
require 'low/scoped_logger'
require 'low/rack/request_logger'

describe Low::Rack::RequestLogger do

  it 'should set rack.logger to an instance of `Low::ScopedLogger` with scope set to \'request_id\'
      and level set to \'low.log_level\'' do
    app = lambda do |env|
      [200, {'Content-Type' => 'text/plain'}, env['rack.logger']]
    end
    rack = Low::Rack::RequestLogger.new app
    response = rack.call({'request_id' => 'abc123', 'low.log_level' => Logger::FATAL})
    logger = response[2]
    logger.should be_a(Low::ScopedLogger)
    logger.scope.should == 'abc123'
    logger.level.should == Logger::FATAL
  end

  it 'should set the specified logger key' do
    app = lambda do |env|
      [200, {'Content-Type' => 'text/plain'}, env['another.logger']]
    end
    rack = Low::Rack::RequestLogger.new app, key: 'another.logger'
    response = rack.call({})
    response[2].should be_a(Low::ScopedLogger)
  end

end
