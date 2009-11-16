require 'lib/rackjour'

module Rackjour
  class Server
    attr_reader :target

    def initialize(target, version, config, tar)
      @target = target
      log 'initialize'

      @tar = tar
      @config = config
      @version = version
      @apps = []
      @deployed = false

      DRb.start_service
      @conn = "druby://#{@target}:#{WORKER_PORT}"
      @drb = DRbObject.new_with_uri(@conn)

      @drb.setup(@version, @config, @tar)
    end

    def deployed?
      @deployed
    end

    def add_jobs(apps)
      apps.each do |app|
        log "job: #{@version} #{app}"
        @drb.add_job(app)
        @jobs << lambda { |env| @drb.call(app, env) }
      end
      @deployed = true
    end

    def call(app, env)
      @drb.call(app, env)
    end

    def log(str)
      puts "#{@target}: #{str}"
    end
  end
end
