require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Currency do
  before(:each) do
    @valid_attributes = {
      :name => "value for name"
    }
  end

  it "should create a new instance given valid attributes" do
    Currency.create!(@valid_attributes)
  end
  
  describe "API" do
    before(:each) do
      @c = Currency::USD.create!(:name => "USD")
    end
    
    it "should provide a url to an icon to represent the currency" do
      @c.api_icon.should == '/images/currency_icon_usd.jpg'
    end
    it "should provide a symbol to represent the currency" do
      @c.api_symbol.should == '$'
    end
    it "should provide a text symbol to represent the currency" do
      @c.api_text_symbol.should == 'USD'
    end
    it "should provide a text name for the currency" do
      @c.api_name.should == 'Dollar'
    end
    it "should provide a text name for the currency in the specified locale" do
#      @c.api_name(:es).should == 'Dolar'
    end
  end
end
