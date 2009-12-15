Then /^I should see the declare button$/ do
  response.should contain(%Q|<input id="weal_submit" name="commit" type="submit" value="Declare" />|)
end

Given /^I declare "([^\"]*)" described as "([^\"]*)" measuring wealth with "([^\"]*)"/ do |title,description,currencies|
  When %Q|I go to the new intentions page|
  And %Q|I fill in "Title" with "#{title}"|
  And %Q|I fill in "Description" with "#{description}"|
  currencies.split(',').each do |currency_name|
    c = Currency.find_by_name(currency_name)
    And %Q|I check "currencies_#{c.id}_used"|
  end
  And %Q|I press "Declare"|
end