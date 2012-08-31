require 'uri'
require 'mongo'

module Low
  module Mongo
    # The `Util` module provides some handy static Mongo helper methods.
    module Util
      # Given a `string`, return all the mongdb URIs contained therein.
      def self.extract_mongodb_uris(string)
        URI.extract(string, 'mongodb')
      end

      def self.heroku_remote_mongo
        # If a mongodb URI can be extracted from heroku config,
        if uri = extract_mongodb_uris(`heroku config`).first

          # build a Mongo::Remote with it.
          Mongo::Remote.new(uri)
        end
      end
    end
  end
end
