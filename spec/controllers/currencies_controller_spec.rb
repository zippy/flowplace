require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CurrenciesController do

  def mock_currency(stubs={})
    @mock_currency ||= mock_model(Currency, stubs)
  end
  
  describe "responding to GET index" do

    it "should expose all currencies as @currencies" do
      Currency.should_receive(:find).with(:all).and_return([mock_currency])
      get :index
      assigns[:currencies].should == [mock_currency]
    end

    describe "with mime type of xml" do
  
      it "should render all currencies as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        Currency.should_receive(:find).with(:all).and_return(currencies = mock("Array of Currencies"))
        currencies.should_receive(:to_xml).and_return("generated XML")
        get :index
        response.body.should == "generated XML"
      end
    
    end

  end

  describe "responding to GET show" do

    it "should expose the requested currency as @currency" do
      Currency.should_receive(:find).with("37").and_return(mock_currency)
      get :show, :id => "37"
      assigns[:currency].should equal(mock_currency)
    end
    
    describe "with mime type of xml" do

      it "should render the requested currency as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        Currency.should_receive(:find).with("37").and_return(mock_currency)
        mock_currency.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37"
        response.body.should == "generated XML"
      end

    end
    
  end

  describe "responding to GET new" do
  
    it "should expose a new currency as @currency" do
      Currency.should_receive(:new).and_return(mock_currency)
      get :new
      assigns[:currency].should equal(mock_currency)
    end

  end

  describe "responding to GET edit" do
  
    it "should expose the requested currency as @currency" do
      Currency.should_receive(:find).with("37").and_return(mock_currency)
      get :edit, :id => "37"
      assigns[:currency].should equal(mock_currency)
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do
      
      it "should expose a newly created currency as @currency" do
        Currency.should_receive(:new).with({'these' => 'params'}).and_return(mock_currency(:save => true))
        post :create, :currency => {:these => 'params'}
        assigns(:currency).should equal(mock_currency)
      end

      it "should redirect to the created currency" do
        Currency.stub!(:new).and_return(mock_currency(:save => true))
        post :create, :currency => {}
        response.should redirect_to(currency_url(mock_currency))
      end
      
    end
    
    describe "with invalid params" do

      it "should expose a newly created but unsaved currency as @currency" do
        Currency.stub!(:new).with({'these' => 'params'}).and_return(mock_currency(:save => false))
        post :create, :currency => {:these => 'params'}
        assigns(:currency).should equal(mock_currency)
      end

      it "should re-render the 'new' template" do
        Currency.stub!(:new).and_return(mock_currency(:save => false))
        post :create, :currency => {}
        response.should render_template('new')
      end
      
    end
    
  end

  describe "responding to PUT udpate" do

    describe "with valid params" do

      it "should update the requested currency" do
        Currency.should_receive(:find).with("37").and_return(mock_currency)
        mock_currency.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :currency => {:these => 'params'}
      end

      it "should expose the requested currency as @currency" do
        Currency.stub!(:find).and_return(mock_currency(:update_attributes => true))
        put :update, :id => "1"
        assigns(:currency).should equal(mock_currency)
      end

      it "should redirect to the currency" do
        Currency.stub!(:find).and_return(mock_currency(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(currency_url(mock_currency))
      end

    end
    
    describe "with invalid params" do

      it "should update the requested currency" do
        Currency.should_receive(:find).with("37").and_return(mock_currency)
        mock_currency.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :currency => {:these => 'params'}
      end

      it "should expose the currency as @currency" do
        Currency.stub!(:find).and_return(mock_currency(:update_attributes => false))
        put :update, :id => "1"
        assigns(:currency).should equal(mock_currency)
      end

      it "should re-render the 'edit' template" do
        Currency.stub!(:find).and_return(mock_currency(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested currency" do
      Currency.should_receive(:find).with("37").and_return(mock_currency)
      mock_currency.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "should redirect to the currencies list" do
      Currency.stub!(:find).and_return(mock_currency(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(currencies_url)
    end

  end

end
