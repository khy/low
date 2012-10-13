require 'low/version'

module Low
  autoload :ScopedLogger, 'low/scoped_logger'
  autoload :Mongo,        'low/mongo'

  module Middleware
    autoload :LogLevel,       'low/middleware/log_level'
    autoload :RackErrors,     'low/middleware/rack_errors'
    autoload :RequestId,      'low/middleware/request_id'
    autoload :RequestLogger,  'low/middleware/request_logger'
    autoload :SubdomainMap,   'low/middleware/subdomain_map'
  end
end
