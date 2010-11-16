require 'spec_helper'

describe AnnotationsController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/annotations" }.should route_to(:controller => "annotations", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/annotations/new" }.should route_to(:controller => "annotations", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/annotations/1" }.should route_to(:controller => "annotations", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/annotations/1/edit" }.should route_to(:controller => "annotations", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/annotations" }.should route_to(:controller => "annotations", :action => "create") 
    end

    it "recognizes and generates #update" do
      { :put => "/annotations/1" }.should route_to(:controller => "annotations", :action => "update", :id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/annotations/1" }.should route_to(:controller => "annotations", :action => "destroy", :id => "1") 
    end
  end
end
