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
    # Add more page name => path mappings here
    
    else
      raise "Can't find mapping from \"#{page_name}\" to a path."
    end
  end
end

World(NavigationHelpers)
