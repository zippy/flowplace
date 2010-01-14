require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CirclesHelper do
  
  #Delete this example and add some real ones or delete this file
  it "should be included in the object returned by #helper" do
    included_modules = (class << helper; self; end).send :included_modules
    included_modules.should include(CirclesHelper)
  end
  
  it "should define users_select" do
  end
  
end
