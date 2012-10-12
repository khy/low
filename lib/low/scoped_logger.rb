require 'logger'

module Low
  # `Low::ScopedLogger` is a tiny wrapper around `Logger`. It allows
  # `scope` to be specified, making it easy to grep any messages generated
  # by a particular instance.
  class ScopedLogger
    attr_accessor :scope

    def initialize(io = $stdout)
      @logger = ::Logger.new(io)
    end

    def level=(level)
      @logger.level = level
    end

    def level
      @logger.level
    end

    def fatal(message = nil, progname = nil, &block)
      add ::Logger::FATAL, message, progname, &block
    end

    def error(message = nil, progname = nil, &block)
      add ::Logger::ERROR, message, progname, &block
    end

    def warn(message = nil, progname = nil, &block)
      add ::Logger::WARN, message, progname, &block
    end

    def info(message = nil, progname = nil, &block)
      add ::Logger::INFO, message, progname, &block
    end

    def debug(message = nil, progname = nil, &block)
      add ::Logger::DEBUG, message, progname, &block
    end

    def add(level, message = nil, progname = nil, &block)
      formatted_message = message
      formatted_message = "[#{@scope}] #{formatted_message}" if @scope
      @logger.add level, formatted_message, progname, &block
    end
  end
end
