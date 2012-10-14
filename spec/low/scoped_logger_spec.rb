require File.dirname(__FILE__) + '/../spec_helper'

describe Low::ScopedLogger do
  describe '#fatal' do
    it 'should emit a fatal message' do
      io = StringIO.new
      logger = Low::ScopedLogger.new(io)
      logger.fatal 'Oh noes!'

      io.rewind; message = io.read
      message.should =~ /FATAL/
      message.should =~ /Oh noes!$/
    end
  end

  describe '#error' do
    it 'should emit an error message' do
      io = StringIO.new
      logger = Low::ScopedLogger.new(io)
      logger.error 'Wrong!'

      io.rewind; message = io.read
      message.should =~ /ERROR/
      message.should =~ /Wrong!$/
    end
  end

  describe '#warn' do
    it 'should emit a warn message' do
      io = StringIO.new
      logger = Low::ScopedLogger.new(io)
      logger.warn 'Watchout!'

      io.rewind; message = io.read
      message.should =~ /WARN/
      message.should =~ /Watchout!$/
    end
  end

  describe '#info' do
    it 'should emit an info message' do
      io = StringIO.new
      logger = Low::ScopedLogger.new(io)
      logger.info 'Such and such'

      io.rewind; message = io.read
      message.should =~ /INFO/
      message.should =~ /Such and such$/
    end
  end

  describe '#debug' do
    it 'should emit a debug message' do
      io = StringIO.new
      logger = Low::ScopedLogger.new(io)
      logger.debug '101011'

      io.rewind; message = io.read
      message.should =~ /DEBUG/
      message.should =~ /101011$/
    end

    it 'should emit nothing if the level is too high' do
      io = StringIO.new
      logger = Low::ScopedLogger.new(io)
      logger.level = ::Logger::INFO
      logger.debug '101011'

      io.rewind; message = io.read
      message.should == ''
    end
  end

  describe '#group_key' do
    it 'should append the specified key to all messages' do
      io = StringIO.new
      logger = Low::ScopedLogger.new(io)
      logger.scope = 'abc123'
      logger.info 'Yadda'

      io.rewind; message = io.read
      message.should =~ /abc123/
      message.should =~ /Yadda$/
    end

    it 'should append the key if the message is specified in a block' do
      io = StringIO.new
      logger = Low::ScopedLogger.new(io)
      logger.scope = 'abc123'
      logger.info { 'Yadda' }

      io.rewind; message = io.read
      message.should =~ /abc123/
      message.should =~ /Yadda$/
    end
  end
end
