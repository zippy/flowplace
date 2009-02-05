require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CurrenciesController do
  describe "route generation" do
    it "should map #index" do
      route_for(:controller => "currencies", :action => "index").should == "/currencies"
    end
  
    it "should map #new" do
      route_for(:controller => "currencies", :action => "new").should == "/currencies/new"
    end
  
    it "should map #show" do
      route_for(:controller => "currencies", :action => "show", :id => 1).should == "/currencies/1"
    end
  
    it "should map #edit" do
      route_for(:controller => "currencies", :action => "edit", :id => 1).should == "/currencies/1/edit"
    end
  
    it "should map #update" do
      route_for(:controller => "currencies", :action => "update", :id => 1).should == "/currencies/1"
    end
  
    it "should map #destroy" do
      route_for(:controller => "currencies", :action => "destroy", :id => 1).should == "/currencies/1"
    end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      params_from(:get, "/currencies").should == {:controller => "currencies", :action => "index"}
    end
  
    it "should generate params for #new" do
      params_from(:get, "/currencies/new").should == {:controller => "currencies", :action => "new"}
    end
  
    it "should generate params for #create" do
      params_from(:post, "/currencies").should == {:controller => "currencies", :action => "create"}
    end
  
    it "should generate params for #show" do
      params_from(:get, "/currencies/1").should == {:controller => "currencies", :action => "show", :id => "1"}
    end
  
    it "should generate params for #edit" do
      params_from(:get, "/currencies/1/edit").should == {:controller => "currencies", :action => "edit", :id => "1"}
    end
  
    it "should generate params for #update" do
      params_from(:put, "/currencies/1").should == {:controller => "currencies", :action => "update", :id => "1"}
    end
  
    it "should generate params for #destroy" do
      params_from(:delete, "/currencies/1").should == {:controller => "currencies", :action => "destroy", :id => "1"}
    end
  end
end
