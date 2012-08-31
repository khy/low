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

      def self.sync_from_remote(local_database_or_mongo, remote)
        # If a Mongo::Local is specified,
        local = local_database_or_mongo.is_a?(Mongo::Local) ?

          # use it,
          local_database_or_mongo :

          # otherwise, assume that it is a database name and build one.
          Mongo::Local.new(local_database_or_mongo)

        # Extract host and port from the remote URI,
        match = remote.uri.match(URI.regexp('mongodb'))
        remote_host = match[4]
        remote_port = match[5]

        # and copy the database.
        local.connection.copy_database(
          remote.database,
          local.database,
          "#{remote_host}:#{remote_port}",
          remote.username,
          remote.password
        )
      end

      def self.sync_heroku(local_database_or_mongo)
        # If there is a remote Heroku Mongo,
        if remote = heroku_remote_mongo

          # sync it to the specified database or Mongo.
          sync_from_remote(local_database_or_mongo, remote)
        end
      end
    end
  end
end
