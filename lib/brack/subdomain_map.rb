module Brack
  # `SubdomainMap` is Rack middleware that delegates to other Rack apps based
  # upon subdomain. It takes two arguments upon initialization:
  #
  # * `base`, the app to be called if there is no subdomain.
  # * `map`, a hash that maps subdomain strings to apps.
  class SubdomainMap
    def initialize(base, map = {})
      @base = base
      @map = map
    end

    def call(env)
      # If the `SERVER_NAME` environment variable has a subdomain
      if env['SERVER_NAME'] =~ /(.*?)\.(?:.*)\..*/
        subdomain = $1
      end

      if subdomain
        # and we can find a corresponding app,
        if app = @map[subdomain]
          # call it and return the result.
          app.call(env)

        # Otherwise, return 403 Forbidden.
        else
          [403, {"Content-Type" => "text/plain"}, []]
        end

      # If there is no subdomain,
      else
        # call the base app and return the result.
        @base.call(env)
      end
    end
  end
end
