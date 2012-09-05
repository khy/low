module Low
  module Mongo
    # The `Heroku` module provides helper methods for Mongo on Heroku.
    module Heroku
      def self.current_remote
        # If a mongodb URI can be extracted from `heroku config`,
        if uri = Mongo::Util.extract_mongodb_uris(`heroku config`).first

          # build a Mongo::Remote with it.
          Mongo::Remote.new(uri)
        end
      end


      def self.sync_current_remote(local_database_or_mongo)
        # If there is a remote Heroku Mongo,
        if remote = Heroku.current_remote

          # sync it to the specified database or Mongo.
          Mongo::Util.sync_from_remote(local_database_or_mongo, remote)
        end
      end
    end
  end
end
