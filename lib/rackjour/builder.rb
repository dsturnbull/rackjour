require 'lib/rackjour'

module Rack
  class Builder
    alias_method :rackjour_local_run, :run
    def run(*args, &block)
      if args.first.class == Rackjour::Master
        Rackjour::Master.begin(args.first)
      end
      rackjour_local_run(*args, &block)
    end

    #def use(middleware, *args, &block)
    #  @ins << lambda do |app|
    #    unless app.class == Class
    #      # override the call method - we will distribute
    #      # from here
    #      override_rack_app(middleware)
    #    end
    #    middleware.new(app, *args, &block)
    #  end
    #end

    def use(middleware, *args, &block)
      @ins << lambda do |app|
        Rackjour::Master.register_app(middleware)
        middleware.new(app, *args, &block)
      end
    end

    def override_rack_app(klass)
      eval <<-EOC
        class ::#{klass}
          alias :rackjour_local_initialize :initialize
          def initialize(app, *args, &block)
            if app.nil?
              rackjour_local_initialize(app, *args, &block)
            else
              remote_app = Rackjour::Master.remote_app(app)
              rackjour_local_initialize(remote_app, *args, &block)
            end
          end
        end
      EOC
    end

    def terminate_rack_app(klass)
      eval <<-EOC
        alias :rackjour_piped_initialize :initialize
        class ::#{klass}
          def initialize(app = nil, *args, &block)
            app = TerminatedApp.new
            rackjour_piped_initialize(app, *args, &block)
          end
        end
      EOC
    end
  end

  class TerminatedApp
    def call(env)
      env
    end
  end
end
