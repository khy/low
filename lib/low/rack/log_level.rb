require 'logger'

module Low
  module Rack
    class LogLevel

      DEFAULT_DEFAULT_LEVEL = Logger::INFO

      def initialize(app, opts = {})
        @app = app
        @default_level = opts[:default_level] || DEFAULT_DEFAULT_LEVEL
      end

      def call(env)
        env['low.log_level'] = log_level
        @app.call(env)
      end

      def log_level
        # If `LOG_LEVEL` is a valid level
        if ['FATAL', 'ERROR', 'WARN', 'INFO', 'DEBUG'].include? ENV['LOG_LEVEL']
          # use it;
          eval "Logger::#{ENV['LOG_LEVEL']}"
        else
          # otherwise, use the default
          @default_level
        end
      end

    end
  end
end