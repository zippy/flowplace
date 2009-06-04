require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PlaysController do
  describe "route generation" do
    it "maps #index" do
      route_for(:controller => "plays", :action => "index").should == "/plays"
    end
  
    it "maps #new" do
      route_for(:controller => "plays", :action => "new").should == "/plays/new"
    end
  
    it "maps #show" do
      route_for(:controller => "plays", :action => "show", :id => "1").should == "/plays/1"
    end
  
    it "maps #edit" do
      route_for(:controller => "plays", :action => "edit", :id => "1").should == "/plays/1/edit"
    end

  it "maps #create" do
    route_for(:controller => "plays", :action => "create").should == {:path => "/plays", :method => :post}
  end

  it "maps #update" do
    route_for(:controller => "plays", :action => "update", :id => "1").should == {:path =>"/plays/1", :method => :put}
  end
  
    it "maps #destroy" do
      route_for(:controller => "plays", :action => "destroy", :id => "1").should == {:path =>"/plays/1", :method => :delete}
    end
  end

  describe "route recognition" do
    it "generates params for #index" do
      params_from(:get, "/plays").should == {:controller => "plays", :action => "index"}
    end
  
    it "generates params for #new" do
      params_from(:get, "/plays/new").should == {:controller => "plays", :action => "new"}
    end
  
    it "generates params for #create" do
      params_from(:post, "/plays").should == {:controller => "plays", :action => "create"}
    end
  
    it "generates params for #show" do
      params_from(:get, "/plays/1").should == {:controller => "plays", :action => "show", :id => "1"}
    end
  
    it "generates params for #edit" do
      params_from(:get, "/plays/1/edit").should == {:controller => "plays", :action => "edit", :id => "1"}
    end
  
    it "generates params for #update" do
      params_from(:put, "/plays/1").should == {:controller => "plays", :action => "update", :id => "1"}
    end
  
    it "generates params for #destroy" do
      params_from(:delete, "/plays/1").should == {:controller => "plays", :action => "destroy", :id => "1"}
    end
  end
end
