Then /^(?:|I )should see an* "([^\"]*)" dashboard item$/ do |text|
  within('#dashboard_'+text.downcase) do |content|
    content.should contain(text)
  end
end
