require 'drb'
require 'dnssd'
require 'tmpdir'
require 'tempfile'
require 'fileutils'

require 'rack'
require 'rack/utils'
require 'rack/builder'

require File.dirname(__FILE__) + '/rackjour/misc'
require File.dirname(__FILE__) + '/rackjour/proxy'
require File.dirname(__FILE__) + '/rackjour/worker'
require File.dirname(__FILE__) + '/rackjour/server'
require File.dirname(__FILE__) + '/rackjour/master'

WORKER_PORT = 9199

