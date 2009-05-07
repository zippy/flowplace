module NavigationHelpers
  def path_to(page_name)
    case page_name
    
    when /the dashboard page/
      '/'
    when /the login page/
      '/login'
    when /the new intentions page/
      '/intentions/new'
    when /the intentions list/
      '/intentions'
      
    # Add more page name => path mappings here
    
    else
      raise "Can't find mapping from \"#{page_name}\" to a path."
    end
  end
end

World(NavigationHelpers)
