require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PlaysController do

  def mock_play(stubs={})
    @mock_play ||= mock_model(Play, stubs)
  end
  
  describe "GET index" do

    it "exposes all plays as @plays" do
      Play.should_receive(:find).with(:all).and_return([mock_play])
      get :index
      assigns[:plays].should == [mock_play]
    end

    describe "with mime type of xml" do
  
      it "renders all plays as xml" do
        Play.should_receive(:find).with(:all).and_return(plays = mock("Array of Plays"))
        plays.should_receive(:to_xml).and_return("generated XML")
        get :index, :format => 'xml'
        response.body.should == "generated XML"
      end
    
    end

  end

  describe "GET show" do

    it "exposes the requested play as @play" do
      Play.should_receive(:find).with("37").and_return(mock_play)
      get :show, :id => "37"
      assigns[:play].should equal(mock_play)
    end
    
    describe "with mime type of xml" do

      it "renders the requested play as xml" do
        Play.should_receive(:find).with("37").and_return(mock_play)
        mock_play.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37", :format => 'xml'
        response.body.should == "generated XML"
      end

    end
    
  end

  describe "GET new" do
  
    it "exposes a new play as @play" do
      Play.should_receive(:new).and_return(mock_play)
      get :new
      assigns[:play].should equal(mock_play)
    end

  end

  describe "GET edit" do
  
    it "exposes the requested play as @play" do
      Play.should_receive(:find).with("37").and_return(mock_play)
      get :edit, :id => "37"
      assigns[:play].should equal(mock_play)
    end

  end

  describe "POST create" do

    describe "with valid params" do
      
      it "exposes a newly created play as @play" do
        Play.should_receive(:new).with({'these' => 'params'}).and_return(mock_play(:save => true))
        post :create, :play => {:these => 'params'}
        assigns(:play).should equal(mock_play)
      end

      it "redirects to the created play" do
        Play.stub!(:new).and_return(mock_play(:save => true))
        post :create, :play => {}
        response.should redirect_to(play_url(mock_play))
      end
      
    end
    
    describe "with invalid params" do

      it "exposes a newly created but unsaved play as @play" do
        Play.stub!(:new).with({'these' => 'params'}).and_return(mock_play(:save => false))
        post :create, :play => {:these => 'params'}
        assigns(:play).should equal(mock_play)
      end

      it "re-renders the 'new' template" do
        Play.stub!(:new).and_return(mock_play(:save => false))
        post :create, :play => {}
        response.should render_template('new')
      end
      
    end
    
  end

  describe "PUT udpate" do

    describe "with valid params" do

      it "updates the requested play" do
        Play.should_receive(:find).with("37").and_return(mock_play)
        mock_play.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :play => {:these => 'params'}
      end

      it "exposes the requested play as @play" do
        Play.stub!(:find).and_return(mock_play(:update_attributes => true))
        put :update, :id => "1"
        assigns(:play).should equal(mock_play)
      end

      it "redirects to the play" do
        Play.stub!(:find).and_return(mock_play(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(play_url(mock_play))
      end

    end
    
    describe "with invalid params" do

      it "updates the requested play" do
        Play.should_receive(:find).with("37").and_return(mock_play)
        mock_play.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :play => {:these => 'params'}
      end

      it "exposes the play as @play" do
        Play.stub!(:find).and_return(mock_play(:update_attributes => false))
        put :update, :id => "1"
        assigns(:play).should equal(mock_play)
      end

      it "re-renders the 'edit' template" do
        Play.stub!(:find).and_return(mock_play(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "DELETE destroy" do

    it "destroys the requested play" do
      Play.should_receive(:find).with("37").and_return(mock_play)
      mock_play.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "redirects to the plays list" do
      Play.stub!(:find).and_return(mock_play(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(plays_url)
    end

  end

end
