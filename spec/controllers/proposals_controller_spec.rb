require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ProposalsController do

  def mock_proposal(stubs={})
    @mock_proposal ||= mock_model(Proposal, stubs)
  end
  
  describe "responding to GET index" do

    it "should expose all proposals as @proposals" do
      Proposal.should_receive(:find).with(:all).and_return([mock_proposal])
      get :index
      assigns[:proposals].should == [mock_proposal]
    end

    describe "with mime type of xml" do
  
      it "should render all proposals as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        Proposal.should_receive(:find).with(:all).and_return(proposals = mock("Array of Proposals"))
        proposals.should_receive(:to_xml).and_return("generated XML")
        get :index
        response.body.should == "generated XML"
      end
    
    end

  end

  describe "responding to GET show" do

    it "should expose the requested proposal as @proposal" do
      Proposal.should_receive(:find).with("37").and_return(mock_proposal)
      get :show, :id => "37"
      assigns[:proposal].should equal(mock_proposal)
    end
    
    describe "with mime type of xml" do

      it "should render the requested proposal as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        Proposal.should_receive(:find).with("37").and_return(mock_proposal)
        mock_proposal.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37"
        response.body.should == "generated XML"
      end

    end
    
  end

  describe "responding to GET new" do
  
    it "should expose a new proposal as @proposal" do
      Proposal.should_receive(:new).and_return(mock_proposal)
      get :new
      assigns[:proposal].should equal(mock_proposal)
    end

  end

  describe "responding to GET edit" do
  
    it "should expose the requested proposal as @proposal" do
      Proposal.should_receive(:find).with("37").and_return(mock_proposal)
      get :edit, :id => "37"
      assigns[:proposal].should equal(mock_proposal)
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do
      
      it "should expose a newly created proposal as @proposal" do
        Proposal.should_receive(:new).with({'these' => 'params'}).and_return(mock_proposal(:save => true))
        post :create, :proposal => {:these => 'params'}
        assigns(:proposal).should equal(mock_proposal)
      end

      it "should redirect to the created proposal" do
        Proposal.stub!(:new).and_return(mock_proposal(:save => true))
        post :create, :proposal => {}
        response.should redirect_to(proposal_url(mock_proposal))
      end
      
    end
    
    describe "with invalid params" do

      it "should expose a newly created but unsaved proposal as @proposal" do
        Proposal.stub!(:new).with({'these' => 'params'}).and_return(mock_proposal(:save => false))
        post :create, :proposal => {:these => 'params'}
        assigns(:proposal).should equal(mock_proposal)
      end

      it "should re-render the 'new' template" do
        Proposal.stub!(:new).and_return(mock_proposal(:save => false))
        post :create, :proposal => {}
        response.should render_template('new')
      end
      
    end
    
  end

  describe "responding to PUT udpate" do

    describe "with valid params" do

      it "should update the requested proposal" do
        Proposal.should_receive(:find).with("37").and_return(mock_proposal)
        mock_proposal.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :proposal => {:these => 'params'}
      end

      it "should expose the requested proposal as @proposal" do
        Proposal.stub!(:find).and_return(mock_proposal(:update_attributes => true))
        put :update, :id => "1"
        assigns(:proposal).should equal(mock_proposal)
      end

      it "should redirect to the proposal" do
        Proposal.stub!(:find).and_return(mock_proposal(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(proposal_url(mock_proposal))
      end

    end
    
    describe "with invalid params" do

      it "should update the requested proposal" do
        Proposal.should_receive(:find).with("37").and_return(mock_proposal)
        mock_proposal.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :proposal => {:these => 'params'}
      end

      it "should expose the proposal as @proposal" do
        Proposal.stub!(:find).and_return(mock_proposal(:update_attributes => false))
        put :update, :id => "1"
        assigns(:proposal).should equal(mock_proposal)
      end

      it "should re-render the 'edit' template" do
        Proposal.stub!(:find).and_return(mock_proposal(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested proposal" do
      Proposal.should_receive(:find).with("37").and_return(mock_proposal)
      mock_proposal.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "should redirect to the proposals list" do
      Proposal.stub!(:find).and_return(mock_proposal(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(proposals_url)
    end

  end

end
