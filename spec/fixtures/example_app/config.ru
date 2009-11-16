require 'vendor/gems/environment'
require 'example'
require 'rackjour'

use Rackjour::Master
use Pokey
use GeoLookup
run Example
