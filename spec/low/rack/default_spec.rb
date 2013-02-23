require File.dirname(__FILE__) + '/../../spec_helper'

require 'low/rack/default'

describe Low::Rack::Default do
  def app(key)
    base = lambda do |env|
      [200, {'Content-Type' => 'text/plain'}, [env[key]]]
    end

    Low::Rack::Default.new(base)
  end

  context 'low.show_exceptions' do
    it 'should set low.show_exceptions to true in development' do
      begin
        ENV['RACK_ENV'] = 'development'
        response = app('low.show_exceptions').call({})
        response[2].first.should == true
      ensure
        ENV['RACK_ENV'] = 'test'
      end
    end

    it 'should set low.show_exceptions to true in test' do
      response = app('low.show_exceptions').call({})
      response[2].first.should == true
    end

    it 'should set low.show_exceptions to false in production' do
      begin
        ENV['RACK_ENV'] = 'production'
        response = app('low.show_exceptions').call({})
        response[2].first.should == false
      ensure
        ENV['RACK_ENV'] = 'test'
      end
    end

    it 'should set low.show_exceptions to false in any other environment' do
      begin
        ENV['RACK_ENV'] = 'stage'
        response = app('low.show_exceptions').call({})
        response[2].first.should == false
      ensure
        ENV['RACK_ENV'] = 'test'
      end
    end
  end
end
