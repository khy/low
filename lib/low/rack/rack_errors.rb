module Low
  module Rack
    class RackErrors

      DEFAULT_FS_ENVS = ['development', 'test']

      def initialize(app, opts = {})
        @app = app
        @fs_envs = opts[:fs_envs] || DEFAULT_FS_ENVS
      end

      def call(env)
        env['rack.errors'] ||= io
        @app.call(env)
      end

      def io
        # If `RACK_ENV` should log to the FS,
        if @fs_envs.include? ENV['RACK_ENV']
          # make sure the log directory exists,
          Dir.mkdir('log') unless Dir.exists?('log')

          # and log to an eponymous file;
          File.open("log/#{ENV['RACK_ENV']}.log", 'a')
        else
          # otherwise, log to STDOUT (Heroku likes it this way).
          STDOUT
        end
      end

    end
  end
end