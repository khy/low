require 'low/rack/default'

module Low
  module Rack

    # +Low::Rack::Exceptions+ is like +Rack::ShowExceptions+, except it will
    # only actually respond with the stack trace when give permission to. Also,
    # it don't do HTML.
    class Exceptions

      def initialize(app, opts = {})
        @app = app
        @logger_key = opts[:logger_key] || Low::Rack::Default::LOGGER_KEY
      end

      def call(env)
        @app.call(env)
      rescue => exception

        # Format the exception trace
        trace = exception.message + "\n" + exception.backtrace.join("\n")

        # and log it, if we have a logger, or raw IO.
        if logger = env[@logger_key]
          logger.fatal trace
        elsif io = env['rack.errors']
          io.puts(trace)
          io.flush
        end

        # Respond with the trace if appropriate.
        if env['low.show_exceptions']
          message = trace
        else
          message = 'An internal server error occurred.'
        end

        [500, {'Content-Type' => 'text/plain'}, [message]]
      end
    end
  end
end
