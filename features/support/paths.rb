module NavigationHelpers
  def path_to(page_name)
    case page_name
    
    when /the login page/
      '/login'
    when /the my wealth stream page/
      '/'
    when /the new intentions page/
      '/intentions/new'
    when /the intentions page/
      '/intentions'
    when /the my currencies page/
      '/my_currencies'
    when /the join currency page/
      '/my_currencies/join'
    when /the my currency accounts page/
      '/currency_accounts'
    when /the circles page/
      '/circles'
    when /the currencies page/
      '/currencies'
    when /the new currencies page/
      '/currencies/new'
    when /the match page/
      '/weals'
    when /the accounts page/
      '/users'
    when /the admin page/
      '/admin'
    when /my currency account "([^\"]*)" play page/
      currency_account_name = $1
      ca = CurrencyAccount.find(:first,:conditions => ['currency_id = ?',CurrencyAccount.find_by_name(currency_account_name)])
      "/currency_accounts/#{ca.id}/play"
    # Add more page name => path mappings here
    
    else
      raise "Can't find mapping from \"#{page_name}\" to a path."
    end
  end
end

World(NavigationHelpers)
