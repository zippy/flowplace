require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ActivitiesController do

  def mock_activity(stubs={})
    @mock_activity ||= mock_model(Activity, stubs)
  end
  
  describe "responding to GET index" do

    it "should expose all activities as @activities" do
      Activity.should_receive(:find).with(:all).and_return([mock_activity])
      get :index
      assigns[:activities].should == [mock_activity]
    end

    describe "with mime type of xml" do
  
      it "should render all activities as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        Activity.should_receive(:find).with(:all).and_return(activities = mock("Array of Activities"))
        activities.should_receive(:to_xml).and_return("generated XML")
        get :index
        response.body.should == "generated XML"
      end
    
    end

  end

  describe "responding to GET show" do

    it "should expose the requested activity as @activity" do
      Activity.should_receive(:find).with("37").and_return(mock_activity)
      get :show, :id => "37"
      assigns[:activity].should equal(mock_activity)
    end
    
    describe "with mime type of xml" do

      it "should render the requested activity as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        Activity.should_receive(:find).with("37").and_return(mock_activity)
        mock_activity.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37"
        response.body.should == "generated XML"
      end

    end
    
  end

  describe "responding to GET new" do
  
    it "should expose a new activity as @activity" do
      Activity.should_receive(:new).and_return(mock_activity)
      get :new
      assigns[:activity].should equal(mock_activity)
    end

  end

  describe "responding to GET edit" do
  
    it "should expose the requested activity as @activity" do
      Activity.should_receive(:find).with("37").and_return(mock_activity)
      get :edit, :id => "37"
      assigns[:activity].should equal(mock_activity)
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do
      
      it "should expose a newly created activity as @activity" do
        Activity.should_receive(:new).with({'these' => 'params'}).and_return(mock_activity(:save => true))
        post :create, :activity => {:these => 'params'}
        assigns(:activity).should equal(mock_activity)
      end

      it "should redirect to the created activity" do
        Activity.stub!(:new).and_return(mock_activity(:save => true))
        post :create, :activity => {}
        response.should redirect_to(activity_url(mock_activity))
      end
      
    end
    
    describe "with invalid params" do

      it "should expose a newly created but unsaved activity as @activity" do
        Activity.stub!(:new).with({'these' => 'params'}).and_return(mock_activity(:save => false))
        post :create, :activity => {:these => 'params'}
        assigns(:activity).should equal(mock_activity)
      end

      it "should re-render the 'new' template" do
        Activity.stub!(:new).and_return(mock_activity(:save => false))
        post :create, :activity => {}
        response.should render_template('new')
      end
      
    end
    
  end

  describe "responding to PUT udpate" do

    describe "with valid params" do

      it "should update the requested activity" do
        Activity.should_receive(:find).with("37").and_return(mock_activity)
        mock_activity.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :activity => {:these => 'params'}
      end

      it "should expose the requested activity as @activity" do
        Activity.stub!(:find).and_return(mock_activity(:update_attributes => true))
        put :update, :id => "1"
        assigns(:activity).should equal(mock_activity)
      end

      it "should redirect to the activity" do
        Activity.stub!(:find).and_return(mock_activity(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(activity_url(mock_activity))
      end

    end
    
    describe "with invalid params" do

      it "should update the requested activity" do
        Activity.should_receive(:find).with("37").and_return(mock_activity)
        mock_activity.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :activity => {:these => 'params'}
      end

      it "should expose the activity as @activity" do
        Activity.stub!(:find).and_return(mock_activity(:update_attributes => false))
        put :update, :id => "1"
        assigns(:activity).should equal(mock_activity)
      end

      it "should re-render the 'edit' template" do
        Activity.stub!(:find).and_return(mock_activity(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested activity" do
      Activity.should_receive(:find).with("37").and_return(mock_activity)
      mock_activity.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "should redirect to the activities list" do
      Activity.stub!(:find).and_return(mock_activity(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(activities_url)
    end

  end

end
