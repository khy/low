require 'logger'

module Low
  module Middleware
    # `RequestLogger` set the env key "logger" to an instance of
    # `Low::ScopedLogger`, with various attributes set according to the state
    # of the request:
    # * _IO_: if RACK_ENV is development or test, use an eponymous file in
    #   the log directory, otherwise use STDOUT (as Heroku likes).
    # * _log_level_: If set, use the LOG_LEVEL environment variable value;
    #   otherwise, use INFO.
    # * _group_key_: Use request_id env value (see the RequestId middleware).
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

      def self.io
        # If `RACK_ENV` is development or test,
        if ['development', 'test'].include? ENV['RACK_ENV']
          # make sure the log directory exists,
          Dir.mkdir('log') unless Dir.exists?('log')

          # and log to the appropriate file;
          File.open("log/#{ENV['RACK_ENV']}.log", 'a')
        else
          # otherwise, log to STDOUT (Heroku likes it this way).
          STDOUT
        end
      end

      DEFAULT_KEY = 'logger'

      def initialize(app, opts = {})
        @app = app
        @key = opts[:key] || DEFAULT_KEY
      end

      def call(env)
        # Set the 'rack.errors' environment key to the above `RequestLogger.io`
        # (other rack components, such as Sinatra, use this),
        env['rack.errors'] = RequestLogger.io

        # instantiate a new `Useless::Logger`,
        logger = Low::ScopedLogger.new(env['rack.errors'])

        # set the logger level to the above `Logger.level`,
        logger.level = RequestLogger.level

        # set the request_id if one is available
        logger.scope = env['request_id']

        # add it to the env,
        env[@key] = logger

        # and call the app
        @app.call(env)
      end
    end
  end
end
