require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CurrencyAccountsController do

  def mock_currency_account(stubs={})
    @mock_currency_account ||= mock_model(CurrencyAccount, stubs)
  end
  
  describe "responding to GET index" do

    it "should expose all currency_accounts as @currency_accounts" do
      CurrencyAccount.should_receive(:find).with(:all).and_return([mock_currency_account])
      get :index
      assigns[:currency_accounts].should == [mock_currency_account]
    end

    describe "with mime type of xml" do
  
      it "should render all currency_accounts as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        CurrencyAccount.should_receive(:find).with(:all).and_return(currency_accounts = mock("Array of CurrencyAccounts"))
        currency_accounts.should_receive(:to_xml).and_return("generated XML")
        get :index
        response.body.should == "generated XML"
      end
    
    end

  end

  describe "responding to GET show" do

    it "should expose the requested currency_account as @currency_account" do
      CurrencyAccount.should_receive(:find).with("37").and_return(mock_currency_account)
      get :show, :id => "37"
      assigns[:currency_account].should equal(mock_currency_account)
    end
    
    describe "with mime type of xml" do

      it "should render the requested currency_account as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        CurrencyAccount.should_receive(:find).with("37").and_return(mock_currency_account)
        mock_currency_account.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37"
        response.body.should == "generated XML"
      end

    end
    
  end

  describe "responding to GET new" do
  
    it "should expose a new currency_account as @currency_account" do
      CurrencyAccount.should_receive(:new).and_return(mock_currency_account)
      get :new
      assigns[:currency_account].should equal(mock_currency_account)
    end

  end

  describe "responding to GET edit" do
  
    it "should expose the requested currency_account as @currency_account" do
      CurrencyAccount.should_receive(:find).with("37").and_return(mock_currency_account)
      get :edit, :id => "37"
      assigns[:currency_account].should equal(mock_currency_account)
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do
      
      it "should expose a newly created currency_account as @currency_account" do
        CurrencyAccount.should_receive(:new).with({'these' => 'params'}).and_return(mock_currency_account(:save => true))
        post :create, :currency_account => {:these => 'params'}
        assigns(:currency_account).should equal(mock_currency_account)
      end

      it "should redirect to the created currency_account" do
        CurrencyAccount.stub!(:new).and_return(mock_currency_account(:save => true))
        post :create, :currency_account => {}
        response.should redirect_to(currency_account_url(mock_currency_account))
      end
      
    end
    
    describe "with invalid params" do

      it "should expose a newly created but unsaved currency_account as @currency_account" do
        CurrencyAccount.stub!(:new).with({'these' => 'params'}).and_return(mock_currency_account(:save => false))
        post :create, :currency_account => {:these => 'params'}
        assigns(:currency_account).should equal(mock_currency_account)
      end

      it "should re-render the 'new' template" do
        CurrencyAccount.stub!(:new).and_return(mock_currency_account(:save => false))
        post :create, :currency_account => {}
        response.should render_template('new')
      end
      
    end
    
  end

  describe "responding to PUT udpate" do

    describe "with valid params" do

      it "should update the requested currency_account" do
        CurrencyAccount.should_receive(:find).with("37").and_return(mock_currency_account)
        mock_currency_account.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :currency_account => {:these => 'params'}
      end

      it "should expose the requested currency_account as @currency_account" do
        CurrencyAccount.stub!(:find).and_return(mock_currency_account(:update_attributes => true))
        put :update, :id => "1"
        assigns(:currency_account).should equal(mock_currency_account)
      end

      it "should redirect to the currency_account" do
        CurrencyAccount.stub!(:find).and_return(mock_currency_account(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(currency_account_url(mock_currency_account))
      end

    end
    
    describe "with invalid params" do

      it "should update the requested currency_account" do
        CurrencyAccount.should_receive(:find).with("37").and_return(mock_currency_account)
        mock_currency_account.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :currency_account => {:these => 'params'}
      end

      it "should expose the currency_account as @currency_account" do
        CurrencyAccount.stub!(:find).and_return(mock_currency_account(:update_attributes => false))
        put :update, :id => "1"
        assigns(:currency_account).should equal(mock_currency_account)
      end

      it "should re-render the 'edit' template" do
        CurrencyAccount.stub!(:find).and_return(mock_currency_account(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested currency_account" do
      CurrencyAccount.should_receive(:find).with("37").and_return(mock_currency_account)
      mock_currency_account.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "should redirect to the currency_accounts list" do
      CurrencyAccount.stub!(:find).and_return(mock_currency_account(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(currency_accounts_url)
    end

  end

end
