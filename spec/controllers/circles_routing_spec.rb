require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CirclesController do
  describe "route generation" do
    it "should map #index" do
      route_for(:controller => "circles", :action => "index").should == "/circles"
    end
  
    it "should map #new" do
      route_for(:controller => "circles", :action => "new").should == "/circles/new"
    end
  
    it "should map #show" do
      route_for(:controller => "circles", :action => "show", :id => 1).should == "/circles/1"
    end
  
    it "should map #edit" do
      route_for(:controller => "circles", :action => "edit", :id => 1).should == "/circles/1/edit"
    end
  
    it "should map #update" do
      route_for(:controller => "circles", :action => "update", :id => 1).should == "/circles/1"
    end
  
    it "should map #destroy" do
      route_for(:controller => "circles", :action => "destroy", :id => 1).should == "/circles/1"
    end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      params_from(:get, "/circles").should == {:controller => "circles", :action => "index"}
    end
  
    it "should generate params for #new" do
      params_from(:get, "/circles/new").should == {:controller => "circles", :action => "new"}
    end
  
    it "should generate params for #create" do
      params_from(:post, "/circles").should == {:controller => "circles", :action => "create"}
    end
  
    it "should generate params for #show" do
      params_from(:get, "/circles/1").should == {:controller => "circles", :action => "show", :id => "1"}
    end
  
    it "should generate params for #edit" do
      params_from(:get, "/circles/1/edit").should == {:controller => "circles", :action => "edit", :id => "1"}
    end
  
    it "should generate params for #update" do
      params_from(:put, "/circles/1").should == {:controller => "circles", :action => "update", :id => "1"}
    end
  
    it "should generate params for #destroy" do
      params_from(:delete, "/circles/1").should == {:controller => "circles", :action => "destroy", :id => "1"}
    end
  end
end
