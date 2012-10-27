require 'logger'
require 'low/scoped_logger'

module Low
  module Rack
    # `RequestLogger` sets 'rack.logger' to an instance of
    # `Low::ScopedLogger`, with `#level` and `#scope` taken from env.
    class RequestLogger

      def initialize(app, opts = {})
        @app = app
      end

      def call(env)
        env['rack.logger'] = logger(env)
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
