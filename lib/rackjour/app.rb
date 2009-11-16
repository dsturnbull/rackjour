module Rackjour
  class App
    attr_reader :version, :name
    def initialize(app, version, config, base_dir, port)
      @app = app
      @version = version
      @base_dir = base_dir
      @config = config
      @port = port

      #make_config
      #Thread.new { run_service }
    end

    def make_config
      #new_config = File.join(@base_dir, "rackjour_#{@app}_config.ru")
      #File.open(new_config, 'w') do |rackjour_config|
      #  rackjour_config << "#\\ -p #{@port}\n"
      #  File.read(File.join(@base_dir, @config)).split("\n").each do |line|
      #    break if line =~ /^\s*use\s/
      #    next  if line =~ /Rackjour::Master/
      #    rackjour_config << line << "\n"
      #  end
      #  rackjour_config << "use #{@app}\n"
      #end
      #log "#{@base_dir} - #{new_config}"
      #puts File.read(new_config)
      #log 'configured'
    end

    def run_service
      while true
        sleep 0.1
        log '.'
      end
    end

    def log(str)
      puts "#{@version}:#{@app}: #{str}"
    end
  end
end
