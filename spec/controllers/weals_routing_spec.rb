require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe WealsController do
  describe "route generation" do
    it "should map #index" do
      route_for(:controller => "weals", :action => "index").should == "/weals"
    end
  
    it "should map #new" do
      route_for(:controller => "weals", :action => "new").should == "/weals/new"
    end
  
    it "should map #show" do
      route_for(:controller => "weals", :action => "show", :id => 1).should == "/weals/1"
    end
  
    it "should map #edit" do
      route_for(:controller => "weals", :action => "edit", :id => 1).should == "/weals/1/edit"
    end
  
    it "should map #update" do
      route_for(:controller => "weals", :action => "update", :id => 1).should == "/weals/1"
    end
  
    it "should map #destroy" do
      route_for(:controller => "weals", :action => "destroy", :id => 1).should == "/weals/1"
    end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      params_from(:get, "/weals").should == {:controller => "weals", :action => "index"}
    end
  
    it "should generate params for #new" do
      params_from(:get, "/weals/new").should == {:controller => "weals", :action => "new"}
    end
  
    it "should generate params for #create" do
      params_from(:post, "/weals").should == {:controller => "weals", :action => "create"}
    end
  
    it "should generate params for #show" do
      params_from(:get, "/weals/1").should == {:controller => "weals", :action => "show", :id => "1"}
    end
  
    it "should generate params for #edit" do
      params_from(:get, "/weals/1/edit").should == {:controller => "weals", :action => "edit", :id => "1"}
    end
  
    it "should generate params for #update" do
      params_from(:put, "/weals/1").should == {:controller => "weals", :action => "update", :id => "1"}
    end
  
    it "should generate params for #destroy" do
      params_from(:delete, "/weals/1").should == {:controller => "weals", :action => "destroy", :id => "1"}
    end
  end
end
