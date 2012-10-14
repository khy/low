require 'logger'

module Low
  # `Low::ScopedLogger` is a tiny extension to `Logger`. It allows
  # `scope` to be specified, making it easy to grep any messages generated
  # by a particular instance.
  class ScopedLogger < Logger
    attr_accessor :scope

    def add(severity, message = nil, progname = nil, &block)
      if message.nil?
        if block_given?
          message = yield
        else
          message = progname
          progname = @progname
        end
      end

      formatted_message = message
      formatted_message = "[#{@scope}] #{formatted_message}" if @scope
      super severity, formatted_message, progname, &block
    end
  end
end
