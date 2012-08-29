require File.dirname(__FILE__) + '/../spec_helper'

describe Low::SubdomainMap do
  def map
    default_app = lambda do |env|
      [200, {'Content-Type' => 'text/plain'}, ['Default App']]
    end

    api_app = lambda do |env|
      [200, {'Content-Type' => 'text/plain'}, ['API App']]
    end

    Low::SubdomainMap.new default_app, 'subdomain' => api_app
  end

  it 'should call the default app if no subdomain is specified' do
    res = Rack::MockRequest.new(map).get('http://useless.info')
    res.should be_ok
    res.body.should == 'Default App'
  end

  it 'should call the appropriate API app if a subdomain is specified' do
    res = Rack::MockRequest.new(map).get('http://subdomain.useless.info')
    res.should be_ok
    res.body.should == 'API App'
  end

  it 'should return a 403 Forbidden if the specified subdomain is not mapped' do
    res = Rack::MockRequest.new(map).get('http://nonexistant.useless.info')
    res.should be_forbidden
  end
end
