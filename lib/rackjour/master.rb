require 'lib/rackjour'

module Rackjour
  class Master
    class << self
      @@apps = []
      @@version = `find . | xargs ruby -rmd5 -e 'puts Digest::SHA256.hexdigest ARGV.map { |file| File.stat(file).mtime }.inject(0) { |sum, mtime| sum += mtime.to_i }.to_s'`.strip

      def to_app
        @ins[-1] = Rack::URLMap.new(@ins.last)  if Hash === @ins.last
        inner_app = @ins.last
        @ins[0...-1].reverse.inject(inner_app) { |a, e| e.call(a) }
      end

      #def call(app, env)
      #  #@@instance.servers.first.call(app.class.to_s, env)
      #  app.call(env)
      #  #require 'ruby-debug'
      #  #debugger
      #  #@@endpoint.call @@instance.servers.first.call(app.class.to_s, env)
      #end

      def register_app(middleware)
        @@apps << middleware
      end

      def begin(instance)
        @@instance.begin
      end
    end

    attr_reader :servers

    def initialize(app)
      @app = app
      @@instance = self
      @servers = []

      if ARGV[0] && File.exist?(ARGV[0])
        @config = File.basename(ARGV[0])
        @base_dir = File.dirname(ARGV[0])
      else
        @config = 'config.ru'
        @base_dir = Dir.pwd
      end

      tar(@base_dir)
    end

    def begin
      Thread.new { discover_workers }
      Thread.new { deploy_apps }
      Thread.new { reaper }
      Thread.new { status }
    end

    def call(env)
      @app.call(env)
    end

    def discover_workers
      begin
        DNSSD.browse '_druby._tcp' do |reply|
          next if reply.flags.more_coming?
          update_workers(reply)
        end
      rescue Exception => e
        p e
        sleep 1
      end
    end

    def deploy_apps
      while true
        begin
          @servers.reject(&:deployed?).each do |server|
            server.add_jobs(@@apps)
          end
        rescue Exception => e
          p e
        end
        sleep 1
      end
    end

    def reaper
      while true
        sleep 1
      end
    end

    def status
      while true
        sleep 1
      end
    end

  private
    def update_workers(reply)
      begin
        if reply.flags.add?
          resolver_service = DNSSD::Service.new.resolve(reply.name,
                                                        reply.type,
                                                        reply.domain) do |r|
            unless @servers.detect { |s| s.target == r.target }
              @servers << Rackjour::Server.new(r.target, @@version, @config, @tar)
            end
          end
          resolver_service.stop
        else
          @servers.delete(reply.domain)
        end
      rescue Exception => e
        p e
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
