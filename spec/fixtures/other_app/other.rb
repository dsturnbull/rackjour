require 'sinatra'

class Auth
  def initialize(app)
    @app = app
  end

  def call(env)
    env['auth'] = true if env['QUERY_STRING'] =~ /secret=wee/
    @app.call(env)
  end
end

class Other < Sinatra::Base
  get '/' do
    "#{env['auth']}, #{env['pokey']}, #{env['location']}\n"
  end
end

