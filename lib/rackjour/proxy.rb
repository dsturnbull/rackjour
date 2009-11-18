module Rackjour
  module Proxy
    def self.const_missing(name)
      proxy_class = Class.new do
        def self.proxy
          true
        end

        def initialize(app)
          @app = app
        end

        def call(env)
          #p Rackjour::Master.servers
          @app.call(env)
        end

      end
      (Rackjour::Proxy).const_set(name, proxy_class)
      (Rackjour::Proxy).const_get(name)
    end
  end
end

