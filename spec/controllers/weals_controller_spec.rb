require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe WealsController do

  def mock_weal(stubs={})
    @mock_weal ||= mock_model(Weal, stubs)
  end
  
  describe "responding to GET index" do

    it "should expose all weals as @weals" do
      Weal.should_receive(:find).with(:all).and_return([mock_weal])
      get :index
      assigns[:weals].should == [mock_weal]
    end

    describe "with mime type of xml" do
  
      it "should render all weals as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        Weal.should_receive(:find).with(:all).and_return(weals = mock("Array of Weals"))
        weals.should_receive(:to_xml).and_return("generated XML")
        get :index
        response.body.should == "generated XML"
      end
    
    end

  end

  describe "responding to GET show" do

    it "should expose the requested weal as @weal" do
      Weal.should_receive(:find).with("37").and_return(mock_weal)
      get :show, :id => "37"
      assigns[:weal].should equal(mock_weal)
    end
    
    describe "with mime type of xml" do

      it "should render the requested weal as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        Weal.should_receive(:find).with("37").and_return(mock_weal)
        mock_weal.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37"
        response.body.should == "generated XML"
      end

    end
    
  end

  describe "responding to GET new" do
  
    it "should expose a new weal as @weal" do
      Weal.should_receive(:new).and_return(mock_weal)
      get :new
      assigns[:weal].should equal(mock_weal)
    end

  end

  describe "responding to GET edit" do
  
    it "should expose the requested weal as @weal" do
      Weal.should_receive(:find).with("37").and_return(mock_weal)
      get :edit, :id => "37"
      assigns[:weal].should equal(mock_weal)
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do
      
      it "should expose a newly created weal as @weal" do
        Weal.should_receive(:new).with({'these' => 'params'}).and_return(mock_weal(:save => true))
        post :create, :weal => {:these => 'params'}
        assigns(:weal).should equal(mock_weal)
      end

      it "should redirect to the created weal" do
        Weal.stub!(:new).and_return(mock_weal(:save => true))
        post :create, :weal => {}
        response.should redirect_to(weal_url(mock_weal))
      end
      
    end
    
    describe "with invalid params" do

      it "should expose a newly created but unsaved weal as @weal" do
        Weal.stub!(:new).with({'these' => 'params'}).and_return(mock_weal(:save => false))
        post :create, :weal => {:these => 'params'}
        assigns(:weal).should equal(mock_weal)
      end

      it "should re-render the 'new' template" do
        Weal.stub!(:new).and_return(mock_weal(:save => false))
        post :create, :weal => {}
        response.should render_template('new')
      end
      
    end
    
  end

  describe "responding to PUT udpate" do

    describe "with valid params" do

      it "should update the requested weal" do
        Weal.should_receive(:find).with("37").and_return(mock_weal)
        mock_weal.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :weal => {:these => 'params'}
      end

      it "should expose the requested weal as @weal" do
        Weal.stub!(:find).and_return(mock_weal(:update_attributes => true))
        put :update, :id => "1"
        assigns(:weal).should equal(mock_weal)
      end

      it "should redirect to the weal" do
        Weal.stub!(:find).and_return(mock_weal(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(weal_url(mock_weal))
      end

    end
    
    describe "with invalid params" do

      it "should update the requested weal" do
        Weal.should_receive(:find).with("37").and_return(mock_weal)
        mock_weal.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :weal => {:these => 'params'}
      end

      it "should expose the weal as @weal" do
        Weal.stub!(:find).and_return(mock_weal(:update_attributes => false))
        put :update, :id => "1"
        assigns(:weal).should equal(mock_weal)
      end

      it "should re-render the 'edit' template" do
        Weal.stub!(:find).and_return(mock_weal(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested weal" do
      Weal.should_receive(:find).with("37").and_return(mock_weal)
      mock_weal.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "should redirect to the weals list" do
      Weal.stub!(:find).and_return(mock_weal(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(weals_url)
    end

  end

end
