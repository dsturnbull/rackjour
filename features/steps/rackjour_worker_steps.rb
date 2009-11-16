Given /^I have a rackjour worker listening$/ do
  @worker = Rackjour::Worker.new
end

Then /^the worker is discoverable$/ do
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

Given /^the worker has been set up$/ do
  pending
end

When /^the worker receives a job request$/ do
end

Then /^the job is deployed$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^the master is notified$/ do
  pending # express the regexp above with the code you wish you had
end

Given /^the worker has a deployed job$/ do
  pending # express the regexp above with the code you wish you had
end

When /^the worker receives a status command$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^the worker replies with a summary of job load$/ do
  pending # express the regexp above with the code you wish you had
end

