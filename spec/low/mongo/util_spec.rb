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

  describe '.sync_from_remote' do
    it 'should delegate to #copy_database on the local connection' do
      local = Low::Mongo::Local.new('low_local')
      remote = Low::Mongo::Remote.new('mongodb://khy:secret@mongo.com:1234/low_remote')
      connection = mock(:connection)
      local.should_receive(:connection).and_return(connection)
      connection.should_receive(:copy_database).with('low_remote', 'low_local', 'mongo.com:1234', 'khy', 'secret')
      Low::Mongo::Util.sync_from_remote(local, remote)
    end
  end
end