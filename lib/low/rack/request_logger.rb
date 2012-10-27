require 'logger'
require 'low/scoped_logger'

module Low
  module Rack
    # `RequestLogger` sets 'rack.logger' to an instance of
    # `Low::ScopedLogger`, with `#level` and `#scope` taken from env.
    class RequestLogger

      DEFAULT_KEY = 'rack.logger'

      def initialize(app, opts = {})
        @app = app
        @key = opts[:key] || DEFAULT_KEY
      end

      def call(env)
        env[@key] = logger(env)
        @app.call(env)
      end

      def logger(env)
        logger = Low::ScopedLogger.new(env['rack.errors'])
        logger.level = env['low.log_level'] || env['log_level']
        logger.scope = env['request_id']
        logger
      end

    end
  end
end
