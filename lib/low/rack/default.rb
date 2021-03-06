module Low
  module Rack
    class Default

      LOGGER_KEY = 'rack.logger'

      def initialize(app)
        @app = app
      end

      def call(env)
        env['low.show_exceptions'] =
          ['development', 'test'].include? ENV['RACK_ENV']

        @app.call(env)
      end
    end
  end
end
