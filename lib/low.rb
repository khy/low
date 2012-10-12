require 'low/version'

module Low
  autoload :Mongo,        'low/mongo'

  module Middleware
    autoload :SubdomainMap, 'low/middleware/subdomain_map'
  end
end
