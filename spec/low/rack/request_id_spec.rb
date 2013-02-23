require File.dirname(__FILE__) + '/../../spec_helper'
require 'low/rack/request_id'

describe Low::Rack::RequestId do
  def app
    app = lambda do |env|
      [200, {'Content-Type' => 'text/plain'}, ['Request Id: ' + env['low.request_id']]]
    end

    Low::Rack::RequestId.new(app)
  end

  it 'should add a request ID to the env while proxying transparently' do
    res = Rack::MockRequest.new(app).get('http://low.edu')
    res.should be_ok
    res.body.should =~ /Request Id: [a-z0-9]{1,}/
  end

  it 'should use the ID specified in the query parameter' do
    res = Rack::MockRequest.new(app).get('http://low.edu?request_id=jah')
    res.should be_ok
    res.body.should == 'Request Id: jah'
  end

  it 'should not use the ID specified it does not have "simple" characters' do
    res = Rack::MockRequest.new(app).get('http://low.edu?request_id=(jah)')
    res.should be_ok
    res.body.should_not == 'Request Id: (jah)'
  end
end
