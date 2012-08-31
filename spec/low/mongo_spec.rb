require File.dirname(__FILE__) + '/../spec_helper'

describe Low::Mongo do
  class MongoTest
    include Low::Mongo

    def host
      'localhost'
    end

    def database
      'low_test'
    end
  end

  describe '#[]' do
    it 'should be a convenience method for access a db collection' do
      mongo = MongoTest.new
      db = double('mongo database')
      collection = double('mongo collection')
      db.should_receive('[]').with('low_collection').and_return(collection)
      mongo.stub db: db
      mongo['low_collection'].should == collection
    end
  end

  describe '#db' do
    it 'should retrieve the specified #database from the connection' do
      mongo = MongoTest.new
      connection = double('mongo connection')
      db = double('mongo database')
      connection.should_receive(:db).with('low_test').and_return(db)
      mongo.stub connection: connection
      mongo.db.should == db
    end
  end

  describe '#connection' do
    it 'should get a new ::Mongo::Connection instance for the specified #host' do
      mongo = MongoTest.new
      connection = double('mongo connection')
      ::Mongo::Connection.should_receive(:new).with('localhost').and_return(connection)
      mongo.connection.should == connection
    end
  end
end

describe Low::Mongo::Local do
  describe '#database' do
    it 'should return the value specified at initialization' do
      mongo = Low::Mongo::Local.new('low_test')
      mongo.database.should == 'low_test'
    end
  end

  describe '#host' do
    it 'should return \'localhost\' if none was specified at initialization' do
      mongo = Low::Mongo::Local.new('low_test')
      mongo.host.should == 'localhost'
    end

    it 'should return the value specified by the named parameter at initialization' do
      mongo = Low::Mongo::Local.new('low_test', host: '0.0.0.0')
      mongo.host.should == '0.0.0.0'
    end
  end

  describe '#username' do
    it 'should return nil if none is specified at initialization' do
      mongo = Low::Mongo::Local.new('low_test')
      mongo.username.should be_nil
    end

    it 'should return the value specified by the named parameter at initialization' do
      mongo = Low::Mongo::Local.new('low_test', username: 'khy')
      mongo.username.should == 'khy'
    end
  end

  describe '#password' do
    it 'should return nil if none is specified at initialization' do
      mongo = Low::Mongo::Local.new('low_test')
      mongo.username.should be_nil
    end

    it 'should return the value specified by the named parameter at initialization' do
      mongo = Low::Mongo::Local.new('low_test', password: 'secret')
      mongo.password.should == 'secret'
    end
  end
end

describe Low::Mongo::Remote do
  describe '#uri' do
    it 'should return the value specified at initialization' do
      mongo = Low::Mongo::Remote.new('mongodb://mongo.com')
      mongo.uri.should == 'mongodb://mongo.com'
    end
  end

  describe '#database' do
    it 'should return a value extracted from the URI' do
      mongo = Low::Mongo::Remote.new('mongodb://khy:secret@mongo.com/low_remote')
      mongo.database.should == 'low_remote'
    end
  end

  describe '#username' do
    it 'should return nil if the URI does not specify a username' do
      mongo = Low::Mongo::Remote.new('mongodb://mongo.com/low_remote')
      mongo.username.should be_nil
    end

    it 'should return the appropriate value extracted from the URI' do
      mongo = Low::Mongo::Remote.new('mongodb://khy:secret@mongo.com/low_remote')
      mongo.username.should == 'khy'
    end
  end

  describe '#password' do
    it 'should return nil if the URI does not specify a password' do
      mongo = Low::Mongo::Remote.new('mongodb://mongo.com/low_remote')
      mongo.password.should be_nil
    end

    it 'should return the appropriate value extracted from the URI' do
      mongo = Low::Mongo::Remote.new('mongodb://khy:secret@mongo.com/low_remote')
      mongo.password.should == 'secret'
    end
  end

  describe '#connection' do
    it 'should pass uri to the ::Mongo::Connection.from_uri method' do
      connection = double('mongo connection')
      ::Mongo::Connection.should_receive(:from_uri).with('mongodb://mongo.com').and_return(connection)
      mongo = Low::Mongo::Remote.new('mongodb://mongo.com')
      mongo.connection.should == connection
    end
  end
end
