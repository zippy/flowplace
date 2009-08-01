require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe WalletsController do

  def mock_wallet(stubs={})
    @mock_wallet ||= mock_model(Wallet, stubs)
  end
  
  describe "GET index" do

    it "exposes all wallets as @wallets" do
      Wallet.should_receive(:find).with(:all).and_return([mock_wallet])
      get :index
      assigns[:wallets].should == [mock_wallet]
    end

    describe "with mime type of xml" do
  
      it "renders all wallets as xml" do
        Wallet.should_receive(:find).with(:all).and_return(wallets = mock("Array of Wallets"))
        wallets.should_receive(:to_xml).and_return("generated XML")
        get :index, :format => 'xml'
        response.body.should == "generated XML"
      end
    
    end

  end

  describe "GET show" do

    it "exposes the requested wallet as @wallet" do
      Wallet.should_receive(:find).with("37").and_return(mock_wallet)
      get :show, :id => "37"
      assigns[:wallet].should equal(mock_wallet)
    end
    
    describe "with mime type of xml" do

      it "renders the requested wallet as xml" do
        Wallet.should_receive(:find).with("37").and_return(mock_wallet)
        mock_wallet.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37", :format => 'xml'
        response.body.should == "generated XML"
      end

    end
    
  end

  describe "GET new" do
  
    it "exposes a new wallet as @wallet" do
      Wallet.should_receive(:new).and_return(mock_wallet)
      get :new
      assigns[:wallet].should equal(mock_wallet)
    end

  end

  describe "GET edit" do
  
    it "exposes the requested wallet as @wallet" do
      Wallet.should_receive(:find).with("37").and_return(mock_wallet)
      get :edit, :id => "37"
      assigns[:wallet].should equal(mock_wallet)
    end

  end

  describe "POST create" do

    describe "with valid params" do
      
      it "exposes a newly created wallet as @wallet" do
        Wallet.should_receive(:new).with({'these' => 'params'}).and_return(mock_wallet(:save => true))
        post :create, :wallet => {:these => 'params'}
        assigns(:wallet).should equal(mock_wallet)
      end

      it "redirects to the created wallet" do
        Wallet.stub!(:new).and_return(mock_wallet(:save => true))
        post :create, :wallet => {}
        response.should redirect_to(wallet_url(mock_wallet))
      end
      
    end
    
    describe "with invalid params" do

      it "exposes a newly created but unsaved wallet as @wallet" do
        Wallet.stub!(:new).with({'these' => 'params'}).and_return(mock_wallet(:save => false))
        post :create, :wallet => {:these => 'params'}
        assigns(:wallet).should equal(mock_wallet)
      end

      it "re-renders the 'new' template" do
        Wallet.stub!(:new).and_return(mock_wallet(:save => false))
        post :create, :wallet => {}
        response.should render_template('new')
      end
      
    end
    
  end

  describe "PUT udpate" do

    describe "with valid params" do

      it "updates the requested wallet" do
        Wallet.should_receive(:find).with("37").and_return(mock_wallet)
        mock_wallet.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :wallet => {:these => 'params'}
      end

      it "exposes the requested wallet as @wallet" do
        Wallet.stub!(:find).and_return(mock_wallet(:update_attributes => true))
        put :update, :id => "1"
        assigns(:wallet).should equal(mock_wallet)
      end

      it "redirects to the wallet" do
        Wallet.stub!(:find).and_return(mock_wallet(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(wallet_url(mock_wallet))
      end

    end
    
    describe "with invalid params" do

      it "updates the requested wallet" do
        Wallet.should_receive(:find).with("37").and_return(mock_wallet)
        mock_wallet.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :wallet => {:these => 'params'}
      end

      it "exposes the wallet as @wallet" do
        Wallet.stub!(:find).and_return(mock_wallet(:update_attributes => false))
        put :update, :id => "1"
        assigns(:wallet).should equal(mock_wallet)
      end

      it "re-renders the 'edit' template" do
        Wallet.stub!(:find).and_return(mock_wallet(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "DELETE destroy" do

    it "destroys the requested wallet" do
      Wallet.should_receive(:find).with("37").and_return(mock_wallet)
      mock_wallet.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "redirects to the wallets list" do
      Wallet.stub!(:find).and_return(mock_wallet(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(wallets_url)
    end

  end

end
