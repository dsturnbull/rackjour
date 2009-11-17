Given /^the worker has been set up$/ do
  pending
end

Given /^the worker has a deployed job$/ do
  pending
end

Given /^I have a rackjour worker listening$/ do
  # @worker = Rackjour::Worker.new
  pending
end

When /^the worker receives a status command$/ do
  pending
end

When /^the worker receives a job request$/ do
  pending
end

Then /^the worker is discoverable$/ do
  # found = []
  # begin
  #   timeout 2 do
  #     DNSSD.browse! '_druby._tcp' do |r|
  #       found << r
  #     end
  #   end
  # rescue TimeoutError
  # end
  # found.map(&:name).should include 'rackjour_worker'
  pending
end

Then /^the job is deployed$/ do
  pending
end

Then /^the job can be called$/ do
  pending
end

Then /^the worker replies with a summary of job load$/ do
  pending
end
