require File.dirname(__FILE__) + '/../../spec_helper'

describe Low::Mongo::Util do
  describe '.extract_mongodb_uris' do
    it 'should return an array of mongodb URIs in the specified string' do
      string = <<-BLOCK
        GEM_PATH:     vendor/bundle/ruby/1.9.1
        LANG:         en_US.UTF-8
        MONGOLAB_URI: mongodb://heroku_app1:secret1@mongolab.com:29827/heroku_app1
        MONGOHQ_URI:  mongodb://heroku_app2:secret2@mongohq.com:29827/heroku_app2
        RANDOM_URI:   http://www.gilt.com 
        PATH:         bin:vendor/bundle/ruby/1.9.1/bin:/usr/local/bin:/usr/bin:/bin
        RACK_ENV:     production
      BLOCK

      uris = Low::Mongo::Util.extract_mongodb_uris(string)
      uris.length.should == 2
      uris.should include('mongodb://heroku_app1:secret1@mongolab.com:29827/heroku_app1')
      uris.should include('mongodb://heroku_app2:secret2@mongohq.com:29827/heroku_app2')
    end
  end
end