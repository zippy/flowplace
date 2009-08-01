require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe WalletsController do
  describe "route generation" do
    it "maps #index" do
      route_for(:controller => "wallets", :action => "index").should == "/wallets"
    end
  
    it "maps #new" do
      route_for(:controller => "wallets", :action => "new").should == "/wallets/new"
    end
  
    it "maps #show" do
      route_for(:controller => "wallets", :action => "show", :id => "1").should == "/wallets/1"
    end
  
    it "maps #edit" do
      route_for(:controller => "wallets", :action => "edit", :id => "1").should == "/wallets/1/edit"
    end

  it "maps #create" do
    route_for(:controller => "wallets", :action => "create").should == {:path => "/wallets", :method => :post}
  end

  it "maps #update" do
    route_for(:controller => "wallets", :action => "update", :id => "1").should == {:path =>"/wallets/1", :method => :put}
  end
  
    it "maps #destroy" do
      route_for(:controller => "wallets", :action => "destroy", :id => "1").should == {:path =>"/wallets/1", :method => :delete}
    end
  end

  describe "route recognition" do
    it "generates params for #index" do
      params_from(:get, "/wallets").should == {:controller => "wallets", :action => "index"}
    end
  
    it "generates params for #new" do
      params_from(:get, "/wallets/new").should == {:controller => "wallets", :action => "new"}
    end
  
    it "generates params for #create" do
      params_from(:post, "/wallets").should == {:controller => "wallets", :action => "create"}
    end
  
    it "generates params for #show" do
      params_from(:get, "/wallets/1").should == {:controller => "wallets", :action => "show", :id => "1"}
    end
  
    it "generates params for #edit" do
      params_from(:get, "/wallets/1/edit").should == {:controller => "wallets", :action => "edit", :id => "1"}
    end
  
    it "generates params for #update" do
      params_from(:put, "/wallets/1").should == {:controller => "wallets", :action => "update", :id => "1"}
    end
  
    it "generates params for #destroy" do
      params_from(:delete, "/wallets/1").should == {:controller => "wallets", :action => "destroy", :id => "1"}
    end
  end
end
