Given /^a circle "([^\"]*)"$/ do |circle_name|
  @user ||= create_user('anonymous')
  CurrencyMembrane.create(@user,{:circle=>{:name => circle_name},:password=>'password',:confirmation=>'password',:email => 'test@test.com'})
end