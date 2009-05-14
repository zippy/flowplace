Given /a "([^\"]*)" currency "([^\"]*)"/ do |currency_type,currency_name|
  @currency = Currency.create!({:type => currency_type, :name => currency_name})
end

Given /I am a member of currency "([^\"]*)"/ do |currency_name|
  c = Currency.find_by_name(currency_name)
  @currency_account = CurrencyAccount.create!({:user => @user, :currency => c})
end