Then /^I should see the declare button$/ do
  response.should contain(%Q|<input id="weal_submit" name="commit" type="submit" value="Declare" />|)
end