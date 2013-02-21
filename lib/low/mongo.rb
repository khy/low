require 'mongo'

module Low
  # The `Mongo` module defines an interface for a Mongo helper
  # class. It also includes two basic classes, `Local` and `Remote`.
  module Mongo
    # Simple access to a Mongo::Collection instance.
    def [](collection)
      db[collection]
    end

    # The environment's Mongo::DB instance.
    def db
      @db ||= connection.db(database)
    end

    # The environment's Mongo::Grid instance - a file store.
    def grid
      @grid ||= ::Mongo::Grid.new(db)
    end

    # The environment's Mongo::Connection instance.
    def connection
      @connection ||= ::Mongo::MongoClient.new(host)
    end

    # The host that `#connection` will use - either this or
    # `#connection` should be overriden.
    def host
    end

    # The database `#db` will use - must be overriden.
    def database
    end

    def username
    end

    def password
    end

    # Force a new connection the next time one is needed
    def reset_connection!
      @grid = nil
      @db = nil
      @connection = nil
    end

    # For connecting to Mongo on localhost.
    class Local
      include Mongo

      attr_reader :host, :database, :username, :password

      # Specify the database upon initialization and
      # assume that the host is localhost (unless told otherwise).
      def initialize(database, opts = {})
        @database = database
        @host = opts[:host] || 'localhost'
        @username = opts[:username]
        @password = opts[:password]
      end
    end

    # For connecting to Mongo via a URI.
    class Remote
      include Mongo

      attr_reader :uri

      # Specify the remote URI upon initialization
      def initialize(uri)
        @uri = uri
      end

      # and use it to connect.
      def connection
        @connection ||= ::Mongo::Connection.from_uri(uri)
      end

      # The database can be extracted from the URI,
      def database
        @uri.match(/.*\/(.*)$/)[1]
      end

      # as can the username,
      def username
        if match = @uri.match(/^.*:\/\/(.*?):.*/)
          match[1]
        end
      end

      # and password.
      def password
        if match = @uri.match(/^.*:\/\/.*?:(.*?)@.*/)
          match[1]
        end
      end
    end
  end
end
