module NavigationHelpers
  def path_to(page_name)
    result = case page_name
    when /the login page/
      '/login'
    when /the logout page/
      '/logout'
    when /the sign up page/
      '/users/signup'
    when /the user activation page/
      u = User.last
      code = u.bolt_identity.activation_code
      "/activations/#{code}?user_name=#{u.user_name}"
    when /the forgot password page/
      '/passwords/forgot'
    when /the reset password page with the reset code for "([^\"]*)"/
      u = User.find_by_user_name($1)
      "/passwords/resetcode?code=#{u.bolt_identity.reset_code}&user_name=#{u.user_name}"
    when /the home page/
      '/'
    when /^the dashboard page$/
      '/dashboard'
    when /^the dashboard activity page$/
      '/dashboard/activity'
    when /the flowplace dashboard page/
      '/dashboard?current_circle='
    when /the dashboard page for "([^\"]*)"/
      i = Currency.find_by_name($1)
      '/dashboard?current_circle='+i.id.to_s
    when /the dashboard activity page for "([^\"]*)"/
      i = Currency.find_by_name($1)
      '/dashboard/activity?current_circle='+i.id.to_s
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
    when /the my proposals page/
      '/intentions/proposed'
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
    when /the current circle members page/
      "/circles/members"
    when /the players page for "([^\"]*)"/
      circle = $1
      i = Currency.find_by_name(circle)
      "/circles/#{i.id}/players"
    when /the link players page for "([^\"]*)"/
      circle = $1
      i = Currency.find_by_name(circle)
      "/circles/#{i.id}/link_players"
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
    when /the edit currency page for "([^\"]*)"/
      circle = $1
      i = Currency.find_by_name(circle)
      "/currencies/#{i.id}/edit"  
    when /the match page/
      '/weals'
    when /the accounts page/
      '/users'
    when /the admin page/
      '/admin'
    when /^the currency account play page for "([^\"]*)"$/
      currency_accounts_paths(:play,$1)
    when /^the currency account history page for "([^\"]*)"$/
      currency_accounts_paths(:history,$1)
    when /^the "([^\"]*)" currency account history page for "([^\"]*)" in "([^\"]*)"( of "([^\"]*)")*$/
      (player_class,user_name,currency_name,dummy,play_name) = [$1,$2,$3,$4,$5]
      u = User.find_by_user_name(user_name)
      raise "couldn't find user #{user_name} while building path '#{page_name}'" if u.nil?
      c = Currency.find_by_name(currency_name)
      raise "couldn't find currency #{currency_name} while building path '#{page_name}'" if c.nil?
      ca = u.currency_accounts.find(:first,:conditions => ["currency_id = ? and player_class = ?",c.id,player_class])
      raise "couldn't find currency account while building path '#{page_name}'" if ca.nil?
      path = "/currency_accounts/#{ca.id}/history"
      path += "/#{play_name}" if play_name
    when /the settings page for my "([^\"]*)" account in "([^\"]*)"/
      user = controller.current_user
      (player_class,currency_name) = [$1,$2]
      currency = Currency.find_by_name(currency_name)
      raise "couldn't find currency '#{currency_name}' while building path" if currency.nil?
      currency_account = CurrencyAccount.find(:first,:conditions => ["user_id = ? and player_class = ? and currency_id = ?",user.id,player_class,currency.id])
      raise "couldn't find a currency account for #{user.user_name} as #{player_class} while building path" if currency_account.nil?
      "/currency_accounts/#{currency_account.id}/settings"
    when /the "([^\"]*)" play page for my "([^\"]*)" account in "([^\"]*)"/
      user = controller.current_user
      (play_name,player_class,currency_name) = [$1,$2,$3]
      currency = Currency.find_by_name(currency_name)
      raise "couldn't find currency '#{currency_name}' while building path" if currency.nil?
      currency_account = CurrencyAccount.find(:first,:conditions => ["user_id = ? and player_class = ? and currency_id = ?",user.id,player_class,currency.id])
      raise "couldn't find a currency account for #{user.user_name} as #{player_class} while building path" if currency_account.nil?
      "/currency_accounts/#{currency_account.id}/play/#{play_name}"
    when /the preferences page/
      "/users/#{controller.current_user.id}/preferences"
    when /the wallets page/
      '/wallets'
    when /the configurations page/
      '/configurations'
    when /the merge default configurations page/
      '/configurations/merge_defaults'
    when /the edit configurations page for "([^\"]*)"/
      config_name = $1
      c = Configuration.find_by_name(config_name)
      raise "couldn't find configuration '#{config_name}' while building path" if c.nil?
      "/configurations/#{c.id}/edit"
    when /the edit user page for "?([^"]*)"?/
      path_to_user_page(:edit,$1)
    when /the show user page for "?([^"]*)"?/
      path_to_user_page(:show,$1)
    when /the add user page/
      path_to_user_page(:add)
    when /the list users page/
      path_to_user_page(:list)
    when /the edit contact info page for "?([^"]*)"?/
      path_to_user_page(:contact_edit,$1)
    when /the view contact info page for "?([^"]*)"?/
      path_to_user_page(:contact_view,$1)
    when /the accept invitation from "([^"]*)" in "([^"]*)" to "([^"]*)" page/
      (user_name,currency_name,email) = [$1,$2,$3]
      u = User.find_by_user_name(user_name)
      raise "couldn't find user '#{user_name}' while building path" if u.nil?
      currency = Currency.find_by_name(currency_name)
      raise "couldn't find currency '#{currency_name}' while building path" if currency.nil?
      currency_account = CurrencyAccount.find(:first,:conditions => ["user_id = ? and player_class = ? and currency_id = ?",u.id,'inviter',currency.id])
      raise "couldn't find a currency account for #{u.user_name} as inviter while building path" if currency_account.nil?
      "/users/accept_invitation/#{currency_account.id}/#{email}"
    else
      begin
        page_name =~ /the (.*) page/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue Object => e
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
    
    if page_name =~ /^page (\d+) of.*with (\d+) per page$/
      page = $1
      per_page = $2
      if page or per_page
        p = []
        p << "page=#{page}" if page
        p << "per_page=#{per_page}" if per_page
        result += "?"+p.join('&')
      end
    end
    result
  end
end

def currency_accounts_paths(kind,locator)
  ca = CurrencyAccount.find_by_name(locator)
  raise "couldn't find currency account for '#{locator}' while building path" if ca.nil?
  case kind
  when :play
    "/currency_accounts/#{ca.id}/play"
  when :history
    play_name = ca.currency.api_play_names(ca.player_class).first
    "/currency_accounts/#{ca.id}/history/#{play_name}"
  end
end

def path_to_user_page(type, locator = nil)
  if locator == "myself"
    locator = controller.current_user.id
  elsif locator
    user = User.find_by_user_name(locator)
    raise "could not find user_name #{locator.inspect} while building user path" if user.nil?
    locator = user.id
  end
  case type
  when :edit
    "/users/#{locator}/edit"
  when :contact_edit
    "/users/#{locator}/contact_info"
  when :contact_view
    "/users/#{locator}/contact_info_read_only"
  when :show
    "/users/#{locator}"
  when :add
    "/users/new"
  when :list
    "/users"
  end
end
World(NavigationHelpers)
