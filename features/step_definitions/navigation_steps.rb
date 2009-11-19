Then /^I should be taken to (.*)$/ do |page|
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

Then /^I should( not)* see "([^\"]*)" as a sub-tab$/ do |should_not,tab_name|
  within('#sub_nav') do |scope|
    if should_not
      scope.should_not contain(tab_name)
    else
      scope.should contain(tab_name)
    end
  end
end

Then /^I should see "([^\"]*)" as the active sub-tab$/ do |tab_name|
  within('#sub_nav') do |scope|
    within('p') do |s|
      should contain(tab_name)
    end
  end
end
    
