Then /^(?:|I )should see an* "([^\"]*)" dashboard item$/ do |name|
  txt = name.tr(' ','_').downcase
  within('#dashboard_'+txt) do |content|
    content.should contain(name)
  end
end

Then /^(?:|I )should see an* "([^\"]*)" "([^\"]*)" dashboard item$/ do |name,player_class|
  txt = name.tr(' ','_').downcase
  within('#dashboard_'+txt+'_'+player_class) do |content|
    content.should contain(name)
  end
end

Then /^(?:|I )should not see an* "([^\"]*)" "([^\"]*)" dashboard item$/ do |name,player_class|
  txt = name.tr(' ','_').downcase+'_'+player_class
  (response.body =~ /#{'dashboard_'+txt}/).should == nil
end

Then /^(?:|I )should not see an* "([^\"]*)" dashboard item$/ do |name|
  txt = name.tr(' ','_').downcase
  (response.body =~ /#{'dashboard_'+txt}/).should == nil
end
