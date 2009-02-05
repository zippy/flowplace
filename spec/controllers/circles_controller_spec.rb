require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CirclesController do

  def mock_circle(stubs={})
    @mock_circle ||= mock_model(Circle, stubs)
  end
  
  describe "responding to GET index" do

    it "should expose all circles as @circles" do
      Circle.should_receive(:find).with(:all).and_return([mock_circle])
      get :index
      assigns[:circles].should == [mock_circle]
    end

    describe "with mime type of xml" do
  
      it "should render all circles as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        Circle.should_receive(:find).with(:all).and_return(circles = mock("Array of Circles"))
        circles.should_receive(:to_xml).and_return("generated XML")
        get :index
        response.body.should == "generated XML"
      end
    
    end

  end

  describe "responding to GET show" do

    it "should expose the requested circle as @circle" do
      Circle.should_receive(:find).with("37").and_return(mock_circle)
      get :show, :id => "37"
      assigns[:circle].should equal(mock_circle)
    end
    
    describe "with mime type of xml" do

      it "should render the requested circle as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        Circle.should_receive(:find).with("37").and_return(mock_circle)
        mock_circle.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37"
        response.body.should == "generated XML"
      end

    end
    
  end

  describe "responding to GET new" do
  
    it "should expose a new circle as @circle" do
      Circle.should_receive(:new).and_return(mock_circle)
      get :new
      assigns[:circle].should equal(mock_circle)
    end

  end

  describe "responding to GET edit" do
  
    it "should expose the requested circle as @circle" do
      Circle.should_receive(:find).with("37").and_return(mock_circle)
      get :edit, :id => "37"
      assigns[:circle].should equal(mock_circle)
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do
      
      it "should expose a newly created circle as @circle" do
        Circle.should_receive(:new).with({'these' => 'params'}).and_return(mock_circle(:save => true))
        post :create, :circle => {:these => 'params'}
        assigns(:circle).should equal(mock_circle)
      end

      it "should redirect to the created circle" do
        Circle.stub!(:new).and_return(mock_circle(:save => true))
        post :create, :circle => {}
        response.should redirect_to(circle_url(mock_circle))
      end
      
    end
    
    describe "with invalid params" do

      it "should expose a newly created but unsaved circle as @circle" do
        Circle.stub!(:new).with({'these' => 'params'}).and_return(mock_circle(:save => false))
        post :create, :circle => {:these => 'params'}
        assigns(:circle).should equal(mock_circle)
      end

      it "should re-render the 'new' template" do
        Circle.stub!(:new).and_return(mock_circle(:save => false))
        post :create, :circle => {}
        response.should render_template('new')
      end
      
    end
    
  end

  describe "responding to PUT udpate" do

    describe "with valid params" do

      it "should update the requested circle" do
        Circle.should_receive(:find).with("37").and_return(mock_circle)
        mock_circle.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :circle => {:these => 'params'}
      end

      it "should expose the requested circle as @circle" do
        Circle.stub!(:find).and_return(mock_circle(:update_attributes => true))
        put :update, :id => "1"
        assigns(:circle).should equal(mock_circle)
      end

      it "should redirect to the circle" do
        Circle.stub!(:find).and_return(mock_circle(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(circle_url(mock_circle))
      end

    end
    
    describe "with invalid params" do

      it "should update the requested circle" do
        Circle.should_receive(:find).with("37").and_return(mock_circle)
        mock_circle.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :circle => {:these => 'params'}
      end

      it "should expose the circle as @circle" do
        Circle.stub!(:find).and_return(mock_circle(:update_attributes => false))
        put :update, :id => "1"
        assigns(:circle).should equal(mock_circle)
      end

      it "should re-render the 'edit' template" do
        Circle.stub!(:find).and_return(mock_circle(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested circle" do
      Circle.should_receive(:find).with("37").and_return(mock_circle)
      mock_circle.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "should redirect to the circles list" do
      Circle.stub!(:find).and_return(mock_circle(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(circles_url)
    end

  end

end
