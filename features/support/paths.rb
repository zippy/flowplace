module NavigationHelpers
  def path_to(page_name)
    case page_name
    
    when /the login page/
      '/login'
    when /the logout page/
      '/logout'
    when /the home page/
      '/'
    when /the dashboard page/
      '/dashboard'
    when /the holoptiview page/
      '/'
    when /the new intentions page/
      '/intentions/new'
    when /the my intentions page/
      '/intentions/my'
    when /the intentions page/
      '/intentions'
    when /the edit intentions page for "([^\"]*)"/
      title = $1
      i = Weal.find_by_title(title)
      "/intentions/#{i.id}/edit"
    when /the view intentions page for "([^\"]*)"/
      title = $1
      i = Weal.find_by_title(title)
      "/intentions/#{i.id}"
    when /the all intentions page/
      '/weals'
    when /the assets page/
      '/assets'
    when /the actions page/
      '/actions'
    when /the my currencies page/
      '/my_currencies'
    when /the join currency page/
      '/my_currencies/join'
    when /the my currency accounts page/
      '/currency_accounts'
    when /the circles page/
      '/circles'
    when /the new circles page/
      '/circles/new'
    when /the edit circle page for "([^\"]*)"/
      circle = $1
      i = Currency.find_by_name(circle)
      "/circles/#{i.id}/edit"
    when /the show circle page for "([^\"]*)"/
      circle = $1
      i = Currency.find_by_name(circle)
      "/circles/#{i.id}"
    when /the players page for "([^\"]*)"/
      circle = $1
      i = Currency.find_by_name(circle)
      "/circles/#{i.id}/players"
    when /the currencies page for "([^\"]*)"/
      circle = $1
      i = Currency.find_by_name(circle)
      "/circles/#{i.id}/currencies"
    when /the currencies page/
      '/currencies'
    when /the new currencies page/
      '/currencies/new'
    when /the new "([^\"]*)" currencies page/
      '/currencies/new?currency_type=Currency'+$1.tr(' ','')
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
    when /the "([^\"]*)" play page for my "([^\"]*)" account in "([^\"]*)"/
      (play_name,player_class,currency) = [$1,$2,$3]
      currency = Currency.find_by_name(currency)
      currency_account = CurrencyAccount.find(:first,:conditions => ["user_id = ? and player_class = ? and currency_id = ?",@user.id,player_class,currency.id])
      "/currency_accounts/#{currency_account.id}/play?name=#{play_name}"
    when /the preferences page/
      "/users/#{controller.current_user.id}/preferences"
    when /the wallets page/
      '/wallets'
    else
      raise "Can't find mapping from \"#{page_name}\" to a path."
    end
  end
end

def currency_accounts_paths(kind,locator)
  ca = CurrencyAccount.find_by_name(locator)
  raise "couldn't find currency account for '#{locator}' while building path" if ca.nil?
  case kind
  when :play
    "/currency_accounts/#{ca.id}/play"
  when :history
    "/currency_accounts/#{ca.id}/history"
  end
end

World(NavigationHelpers)
