require 'low/version'

module Low
  autoload :ScopedLogger, 'low/scoped_logger'
  autoload :Mongo,        'low/mongo'

  module Middleware
    autoload :RequestLogger,  'low/middleware/request_logger'
    autoload :SubdomainMap,   'low/middleware/subdomain_map'
  end
end
