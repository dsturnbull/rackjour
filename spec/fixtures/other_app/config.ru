#\ -p 9293
require 'vendor/gems/environment'
require 'other'
require '../../../lib/rackjour'

use Rackjour::Master
use Rackjour::Proxy::Pokey
use Rackjour::Proxy::Geokit
use Auth
run Other
