require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ProposalsController do
  describe "route generation" do
    it "should map #index" do
      route_for(:controller => "proposals", :action => "index").should == "/proposals"
    end
  
    it "should map #new" do
      route_for(:controller => "proposals", :action => "new").should == "/proposals/new"
    end
  
    it "should map #show" do
      route_for(:controller => "proposals", :action => "show", :id => 1).should == "/proposals/1"
    end
  
    it "should map #edit" do
      route_for(:controller => "proposals", :action => "edit", :id => 1).should == "/proposals/1/edit"
    end
  
    it "should map #update" do
      route_for(:controller => "proposals", :action => "update", :id => 1).should == "/proposals/1"
    end
  
    it "should map #destroy" do
      route_for(:controller => "proposals", :action => "destroy", :id => 1).should == "/proposals/1"
    end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      params_from(:get, "/proposals").should == {:controller => "proposals", :action => "index"}
    end
  
    it "should generate params for #new" do
      params_from(:get, "/proposals/new").should == {:controller => "proposals", :action => "new"}
    end
  
    it "should generate params for #create" do
      params_from(:post, "/proposals").should == {:controller => "proposals", :action => "create"}
    end
  
    it "should generate params for #show" do
      params_from(:get, "/proposals/1").should == {:controller => "proposals", :action => "show", :id => "1"}
    end
  
    it "should generate params for #edit" do
      params_from(:get, "/proposals/1/edit").should == {:controller => "proposals", :action => "edit", :id => "1"}
    end
  
    it "should generate params for #update" do
      params_from(:put, "/proposals/1").should == {:controller => "proposals", :action => "update", :id => "1"}
    end
  
    it "should generate params for #destroy" do
      params_from(:delete, "/proposals/1").should == {:controller => "proposals", :action => "destroy", :id => "1"}
    end
  end
end
