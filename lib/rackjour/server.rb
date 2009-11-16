require 'lib/rackjour'

module Rackjour
  class Server
    attr_reader :target

    def initialize(target, version, tar)
      @target = target
      log 'initialize'

      @tar = tar
      @version = version
      @apps = []
      @deployed = false

      DRb.start_service
      @conn = "druby://#{@target}:#{WORKER_PORT}"
      @drb = DRbObject.new_with_uri(@conn)

      @drb.setup(@version, @tar)
    end

    def deployed?
      @deployed
    end

    def add_apps(apps, terminator)
      (apps - [terminator]).each do |app|
        log "job: #{@version} #{app}"
        @drb.add_app(app)
      end
      log "job: #{@version} #{terminator} (terminator)"
      @drb.add_terminator(terminator)
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
