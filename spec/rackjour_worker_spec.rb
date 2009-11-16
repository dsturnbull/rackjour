require 'spec_helper.rb'

describe Rackjour::Worker do
  before :all do
    @worker = Rackjour::Worker.new
  end

  it 'should respond to mdns' do

    found = []
    begin
      timeout 2 do
        DNSSD.browse! '_druby._tcp' do |r|
          found << r
        end
      end
    rescue TimeoutError
    end

    found.map(&:name).should include 'rackjour_worker'
  end

  it 'should be setup' do
  end

  it 'should accept jobs via drb' do
    drb_client = DRbObject.new_with_uri("druby://localhost:#{WORKER_PORT}")
    port = drb_client.add_job('job_id', 'Rack::SomeRackApp')
    port.should be_instance_of Fixnum
  end

  it 'should receive requests for setup jobs and return' do
  end
end
