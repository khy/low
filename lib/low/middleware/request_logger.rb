require 'logger'

module Low
  module Middleware
    # `RequestLogger` sets 'rack.logger' to an instance of
    # `Low::ScopedLogger`, with `#level` and `#scope` taken from env.
    class RequestLogger
      def self.level
        # If `LOG_LEVEL` is a valid level other than INFO,
        if ['FATAL', 'ERROR', 'WARN', 'DEBUG'].include? ENV['LOG_LEVEL']
          # use it;
          eval "::Logger::#{ENV['LOG_LEVEL']}"
        else
          # otherwise, use `::Logger::INFO`
          ::Logger::INFO
        end
      end

      def initialize(app, opts = {})
        @app = app
      end

      def call(env)
        # Instantiate a new `Useless::Logger` using 'rack.errors',
        logger = Low::ScopedLogger.new(env['rack.errors'])

        # set the logger level to the above `Logger.level`,
        logger.level = RequestLogger.level

        # set the request_id if one is available
        logger.scope = env['request_id']

        # add it to the env,
        env['rack.logger'] = logger

        # and call the app.
        @app.call(env)
      end
    end
  end
end
