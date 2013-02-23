require File.dirname(__FILE__) + '/../../spec_helper'

require 'rack/mock'

require 'low/rack/exceptions'
require 'low/scoped_logger'

describe Low::Rack::Exceptions do

  it 'should proxy successful calls transparently' do
    base = lambda do |env|
      [200, {'Content-Type' => 'text/plain'}, ['No Problems!']]
    end
    app = Low::Rack::Exceptions.new(base)

    response = Rack::MockRequest.new(app).get('http://low.edu')
    response.should be_ok
    response.body.should == 'No Problems!'
  end

  it 'should log a stack trace to rack.logger when an error occurs' do
    base = lambda { |env| raise 'gurp' }
    app = Low::Rack::Exceptions.new(base)
    io = StringIO.new

    app.call('rack.logger' => Low::ScopedLogger.new(io))
    io.rewind
    lines = io.read.split("\n")
    lines.length.should be > 5
    lines.first.should =~ /gurp/
  end

  it 'should log a stack trace to rack.errors when an error occurs, and ' +
     'rack.logger is not specified' do
    base = lambda { |env| raise 'gurp' }
    app = Low::Rack::Exceptions.new(base)
    io = StringIO.new

    app.call('rack.errors' => io)
    io.rewind
    lines = io.read.split("\n")
    lines.length.should be > 5
    lines.first.should =~ /gurp/
  end

  it 'should respond with a 500 when an error occurs' do
    base = lambda { |env| raise 'blurp' }
    app = Low::Rack::Exceptions.new(base)

    response = Rack::MockRequest.new(app).get('http://low.edu')
    response.status.should == 500
  end

  it 'should include the trace in the response if low.show_exceptions is true' do
    base = lambda { |env| raise 'glerb' }
    app = Low::Rack::Exceptions.new(base)

    response = app.call('low.show_exceptions' => true)
    lines = response[2].first.split("\n")
    lines.length.should be > 5
    lines.first.should =~ /glerb/
  end

  it 'should show a generic message if low.show_exceptions is falsey' do
    base = lambda { |env| raise 'glorp' }
    app = Low::Rack::Exceptions.new(base)

    response = app.call({})
    response[2].first.should == 'An internal server error occurred.'
  end
end
