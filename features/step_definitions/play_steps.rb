Then /^I should( not)* see "([^\"]*)" as a possible play$/ do |should_not,play_name|
  within('.play_names') do |scope|
    if should_not
      scope.should_not contain(play_name)
    else
      scope.should contain(play_name)
    end
  end
end

Then /^I should see "([^\"]*)" as the active play$/ do |play_name|
  within('.play_names') do |scope|
    within('p') do |s|
      s.should contain(play_name)
    end
  end
end
