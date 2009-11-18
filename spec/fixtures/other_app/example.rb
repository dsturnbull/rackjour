require 'sinatra'
require 'geokit'

class GeoLookup
  def initialize(app)
    @app = app
  end

  def call(env)
    ip = env['REMOTE_ADDR'] == '127.0.0.1' ? '12.12.12.12' : env['REMOTE_ADDR']
    env['location'] = Geokit::Geocoders::MultiGeocoder.geocode(ip)
    @app.call(env)
  end
end

class Pokey
  def initialize(app)
    @app = app
  end

  def call(env)
    env['pokey'] = 'I DO NOT LIKE THIS GRAVITY!'
    @app.call(env)
  end
end

class Example < Sinatra::Base
  get '/' do
    env['location'].to_s
  end
end

