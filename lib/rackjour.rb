require 'drb'
require 'dnssd'
require 'tmpdir'
require 'tempfile'
require 'fileutils'

require 'rack'
require 'rack/utils'
require 'rack/builder'

require 'rackjour/worker'
require 'rackjour/server'
require 'rackjour/master'

WORKER_PORT = 9199

