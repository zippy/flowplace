Then /^The last email delivered is from "([^\"]*)" and to "([^\"]*)"$/ do |from,to|
  ActionMailer::Base.deliveries.last.from.join(',').should == from
  ActionMailer::Base.deliveries.last.to.join(',').should == to
end

Then /^The last email delivered contains "([^\"]*)"$/ do |text|
  ActionMailer::Base.deliveries.last.body.should contain(text)
end
