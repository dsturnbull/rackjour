# FIXME once gemmed
require 'vendor/gems/environment'
require 'spec/fixtures/example_app/example'
require 'lib/rackjour'

use Rackjour::Master
use Pokey
use GeoLookup
run Example
