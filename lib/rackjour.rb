require 'vendor/gems/environment.rb'

require 'drb'
require 'dnssd'
require 'tmpdir'
require 'tempfile'
require 'fileutils'
require 'memcached'

require 'rack'
require 'rack/utils'
require 'rack/builder'

require 'lib/rackjour/app'
require 'lib/rackjour/worker'
require 'lib/rackjour/server'
require 'lib/rackjour/master'
require 'lib/rackjour/builder'

WORKER_PORT = 9199

