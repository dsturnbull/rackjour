module Rackjour
  class Worker
    @@started = false

    def initialize
      unless @@started
        @@started = true
        DNSSD.register('rackjour_worker', '_druby._tcp', nil, 9199)
        DRb.start_service("druby://0.0.0.0:#{WORKER_PORT}", Worker.new)
        DRb.thread.join
      end
    end

    def add_app(app)
      @apps ||= {}
      log "job: #{@version} #{app}"
      capp = constantize(app)
      rack_app = capp.new(lambda { |env| env })
      @apps[app] = rack_app
    end

    def add_terminator(app)
      log "job: #{@version} #{app} (terminator)"
      capp = constantize(app)
      @apps[app] = capp.new
    end

    def setup(version, tar, config)
      @version = version
      @deployed = false
      @config = config

      @base_dir = Dir.mktmpdir
      log "installing to #{@base_dir}"

      Dir.chdir @base_dir do
        File.open(File.join(@base_dir, 'app.tgz'), 'w') do |file|
          file << tar
        end
        `tar zxf app.tgz`
      end

      load_deps
    end

    def call(app, env)
      log app
      @apps[app].call(env)
    end

    def load_deps
      Dir.chdir(@base_dir) do
        File.readlines(@config).each do |line|
          if line !~ /rackjour/ && line =~ /require ['"](.+)['"]$/
            req = $1
            req = File.join(@base_dir, req) if req =~ /environment/
            log req
            require req
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
