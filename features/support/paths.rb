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
    when /the currency account play page for "([^\"]*)"/
      currency_accounts_paths(:play,$1)
    when /the currency account history page for "([^\"]*)"/
      currency_accounts_paths(:history,$1)
    when /the preferences page/
      "/users/#{controller.current_user.id}/preferences"
    else
      raise "Can't find mapping from \"#{page_name}\" to a path."
    end
  end
end

def currency_accounts_paths(kind,locator)
  ca = CurrencyAccount.find_by_name(locator)
  case kind
  when :play
    "/currency_accounts/#{ca.id}/play"
  when :history
    "/currency_accounts/#{ca.id}/history"
  end
end

World(NavigationHelpers)
