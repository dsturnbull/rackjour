Thread.abort_on_exception = true

module Rackjour
  class Master
    attr_reader :servers

    class << self
      @@version = 'x.x.x'
      @@instance = nil

      def method_missing(method, *args, &block)
        p @@instance
         @@instance.send(method, *args, &block)
      end
    end

    def initialize(app)
      @app = app
      @@instance = self
      @servers = []

      if ARGV[0] && File.exist?(ARGV[0])
        @base_dir = File.dirname(ARGV[0])
        @config = File.basename(ARGV[0])
      else
        @base_dir = Dir.pwd
        @config = 'config.ru'
      end

      tar(@base_dir)

      sleep 1

      load_apps
      Thread.new { discover_workers }
      Thread.new { deploy_apps }
    end

    def call(env)
      if @servers.any?
        @apps.each do |app|
          env = call_handling_proxies(app, env)
        end
        env
      else
        call_handling_proxies(@app, env)
      end
    end

    def call_handling_proxies(app, env)
      if constantize(app).respond_to? :proxy
        app = app.split(/::/).last
      end
      @servers.first.call(app, env)
    end

    def discover_workers
      DNSSD.browse('_druby._tcp') do |reply|
        next if reply.flags.more_coming?
        update_workers(reply)
      end
    end

    def deploy_apps
      while true
        @servers.reject(&:deployed?).each do |server|
          server.add_apps(@apps, @terminator)
        end
        sleep 1
      end
    end

  private
    def load_apps
      @apps ||= []
      return @apps unless @apps.empty?

      next_app = @app
      while true
        @apps << next_app.class.to_s
        next_app = next_app.instance_eval { @app }

        break if next_app.nil?

        if next_app.class == Class
          @apps << next_app.to_s
          break
        end
      end
      @terminator = @apps.last
      @apps
    end

    def update_workers(reply)
      if reply.flags.add?
        resolver_service = DNSSD::Service.new.resolve(
          reply.name,
          reply.type,
          reply.domain
        ) do |r|
          unless @servers.detect { |s| s.target == r.target }
            @servers << Rackjour::Server.new(r.target, @@version, @tar, @config)
          end
        end
        resolver_service.stop
      else
        @servers.delete(reply.domain)
      end
    end

    def tar(base_dir)
      t = Tempfile.new("rackjour_project")
      if `tar czf #{t.path} -C #{base_dir} . 2>/dev/null`
        t.close
        @tar = File.read(t.path)
        log "tarred #{base_dir} #{@tar.size} (#{@@version})"
      end
    end

    def log(str)
      puts "master: #{str}"
    end
  end
end
