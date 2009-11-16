require 'lib/rackjour'
require 'spec/fixtures/example_app/example' # FIXME once gemmed

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
      rack_app = app.new(lambda { |env| env })
      @apps[app] = rack_app
    end

    def add_terminator(app)
      log "job: #{@version} #{app} (terminator)"
      @apps[app] = app.new
    end

    def setup(version, tar)
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
      log app
      @apps[app].call(env)
    end

    def log(str)
      puts "worker: #{str}"
    end
  end
end

if __FILE__ == $0
  Rackjour::Worker.new
end
