Given /a "([^\"]*)" currency "([^\"]*)"/ do |currency_type,currency_name|
  @currency = Currency.create!({:type => currency_type, :name => currency_name})
end

Given /^I am a member of currency "([^\"]*)"/ do |currency_name|
  c = Currency.find_by_name(currency_name)
  @currency_account = CurrencyAccount.create!({:user => @user, :currency => c})
end

Given /^"([^\"]*)" is a member of currency "([^\"]*)"/ do |user,currency_name|
  joe = create_user(user)
  c = Currency.find_by_name(currency_name)
  @currency_account = CurrencyAccount.create!({:user => joe, :currency => c})
end

When /^I follow "([^\"]*)" for currency "([^\"]*)"$/ do |link,currency_name|
  c = Currency.find_by_name(currency_name)
  within('tr#currency_'+c.name_as_html_id) do |scope|
    click_link(link)
  end
end

Then /^I should( not)* see a currency "([^\"]*)"$/ do |should_not,currency_name|
  c = Currency.find_by_name(currency_name)

  # if we shouldn't see the currency then within should raise an error
  if should_not
    lambda {within('tr#currency_'+c.name_as_html_id) {}}.should raise_error
  else
    lambda {within('tr#currency_'+c.name_as_html_id) {}}.should_not raise_error
  end
end