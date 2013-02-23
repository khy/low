require 'rack/request'

module Low
  module Rack
    # `RequestId` adds a value for env["request_id"]. `RequestLogger`, for one,
    # uses this value to scope the logger it instantiates.
    class RequestId
      @@request_id = 0

      VALID_REQUEST_ID_REGEX = /^[a-zA-Z0-9\s\-_]*$/

      def self.is_valid?(id)
        id =~ VALID_REQUEST_ID_REGEX
      end

      def initialize(app)
        @app = app

        #generate a request ID (not too worried about uniqueness here).
        @current_request_id = (@@request_id += 1)
      end

      def call(env)
        # If there is a request_id parameter,
        req = ::Rack::Request.new(env)

        # and it's valid, use it;
        if req['request_id'] and RequestId.is_valid?(req['request_id'])
          env['low.request_id'] = req['request_id']

        # otherwise, use the generated one
        else
          env['low.request_id'] = @current_request_id.to_s
        end

        # and call the app.
        @app.call(env)
      end
    end
  end
end
