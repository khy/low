require File.dirname(__FILE__) + '/../spec_helper'

describe Brack::Mongo do
  class MongoTest
    include Brack::Mongo

    def host
      'localhost'
    end

    def database
      'brack_test'
    end
  end

  describe '#[]' do
    it 'should be a convenience method for access a db collection' do
      mongo = MongoTest.new
      db = double('mongo database')
      collection = double('mongo collection')
      db.should_receive('[]').with('brack_collection').and_return(collection)
      mongo.stub db: db
      mongo['brack_collection'].should == collection
    end
  end

  describe '#db' do
    it 'should retrieve the specified #database from the connection' do
      mongo = MongoTest.new
      connection = double('mongo connection')
      db = double('mongo database')
      connection.should_receive(:db).with('brack_test').and_return(db)
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

describe Brack::Mongo::Local do
  describe '#database' do
    it 'should return the value specified at initialization' do
      mongo = Brack::Mongo::Local.new('brack_test')
      mongo.database.should == 'brack_test'
    end
  end

  describe '#host' do
    it 'should return \'localhost\' if none was specified at initialization' do
      mongo = Brack::Mongo::Local.new('brack_test')
      mongo.host.should == 'localhost'
    end

    it 'should return the value specified at initialization' do
      mongo = Brack::Mongo::Local.new('brack_test', '0.0.0.0')
      mongo.host.should == '0.0.0.0'
    end
  end
end

describe Brack::Mongo::Remote do
  describe '#uri' do
    it 'should return the value specified at initialization' do
      mongo = Brack::Mongo::Remote.new('mongodb://mongo.com')
      mongo.uri.should == 'mongodb://mongo.com'
    end
  end

  describe '#database' do
    it 'should return a value extracted from the URI' do
      mongo = Brack::Mongo::Remote.new('mongodb://khy:secret@mongo.com/brack_remote')
      mongo.database.should == 'brack_remote'
    end
  end

  describe '#connection' do
    it 'should pass uri to the ::Mongo::Connection.from_uri method' do
      connection = double('mongo connection')
      ::Mongo::Connection.should_receive(:from_uri).with('mongodb://mongo.com').and_return(connection)
      mongo = Brack::Mongo::Remote.new('mongodb://mongo.com')
      mongo.connection.should == connection
    end
  end
end
