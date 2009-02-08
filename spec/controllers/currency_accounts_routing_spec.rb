require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CurrencyAccountsController do
  describe "route generation" do
    it "should map #index" do
      route_for(:controller => "currency_accounts", :action => "index").should == "/currency_accounts"
    end
  
    it "should map #new" do
      route_for(:controller => "currency_accounts", :action => "new").should == "/currency_accounts/new"
    end
  
    it "should map #show" do
      route_for(:controller => "currency_accounts", :action => "show", :id => 1).should == "/currency_accounts/1"
    end
  
    it "should map #edit" do
      route_for(:controller => "currency_accounts", :action => "edit", :id => 1).should == "/currency_accounts/1/edit"
    end
  
    it "should map #update" do
      route_for(:controller => "currency_accounts", :action => "update", :id => 1).should == "/currency_accounts/1"
    end
  
    it "should map #destroy" do
      route_for(:controller => "currency_accounts", :action => "destroy", :id => 1).should == "/currency_accounts/1"
    end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      params_from(:get, "/currency_accounts").should == {:controller => "currency_accounts", :action => "index"}
    end
  
    it "should generate params for #new" do
      params_from(:get, "/currency_accounts/new").should == {:controller => "currency_accounts", :action => "new"}
    end
  
    it "should generate params for #create" do
      params_from(:post, "/currency_accounts").should == {:controller => "currency_accounts", :action => "create"}
    end
  
    it "should generate params for #show" do
      params_from(:get, "/currency_accounts/1").should == {:controller => "currency_accounts", :action => "show", :id => "1"}
    end
  
    it "should generate params for #edit" do
      params_from(:get, "/currency_accounts/1/edit").should == {:controller => "currency_accounts", :action => "edit", :id => "1"}
    end
  
    it "should generate params for #update" do
      params_from(:put, "/currency_accounts/1").should == {:controller => "currency_accounts", :action => "update", :id => "1"}
    end
  
    it "should generate params for #destroy" do
      params_from(:delete, "/currency_accounts/1").should == {:controller => "currency_accounts", :action => "destroy", :id => "1"}
    end
  end
end
