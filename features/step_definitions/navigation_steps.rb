Then "$actor should be taken to (.*)" do |actor,page|
  request.env["REQUEST_URI"].should == path_to(page)
end

Then /^I should( not)* see "([^\"]*)" as the current tab$/ do |should_not,tab_name|
  within('a.active') do |scope|
    if should_not
      scope.should_not contain(tab_name)
    else
      scope.should contain(tab_name)
    end
  end
end