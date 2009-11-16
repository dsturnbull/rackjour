require 'lib/rackjour'

module Rackjour
  class Worker
    include DRbUndumped

    @@started = false

    def initialize
      unless @@started
        @@started = true
        DNSSD.register('rackjour_worker', '_druby._tcp', nil, 9199)
        DRb.start_service("druby://0.0.0.0:#{WORKER_PORT}", Worker.new)
        DRb.thread.join
      end
    end

    def add_job(app)
      log "#{@version} #{app}"
      @apps ||= {}
      #app = Rackjour::App.new(app, @version, @config, @base_dir, app_port(app))
    end

    def setup(version, config, tar)
      @config = config
      @version = version
      @deployed = false

      @base_dir = Dir.mktmpdir
      log "installing to #{@base_dir}"

      Dir.chdir @base_dir do
        File.open(File.join(@base_dir, 'app.tgz'), 'w') do |file|
          file << tar
        end
        `tar zxf app.tgz`
      end

      #load_deps
    end

    def call(app, env)
      unless app.nil?
        #Rack::Builder.new.override_rack_app(app)
        app.new.call(env)
      end
      #if @apps[app]
      #  log "handling request for #{app}"
      #  @apps[app].rackjour_local_call(env)
      #else
      #  {}
      #end
    end

    def load_deps
      Dir.chdir(@base_dir) do
        File.read(@config).split("\n").each do |line|
          if line =~ /^require/
            eval line
          end
        end
      end
    end

    def log(str)
      puts "worker: #{str}"
    end
  end
end

if __FILE__ == $0
  Rackjour::Worker.new
end
