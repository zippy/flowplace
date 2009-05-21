require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Currency do
  before(:each) do
    @valid_attributes = {
      :name => "My Currency",
      :icon_url => "/images/my_currency.gif",
      :symbol => "MC"
    }
  end

  it "should create a new instance given valid attributes" do
    c = Currency.create!(@valid_attributes)
  end

  it "should raise an error given no name attribute" do
    lambda {Currency.create!}.should raise_error
  end
  
  it "should be able to report a name suitable for use as an html id" do
    c = Currency.create!(@valid_attributes)
    c.name_as_html_id.should == 'my_currency'
  end
  
  describe "currency autoload" do
    it "should create currency classes for xgfl files in the currencies directory" do
      CurrencyMutualCredit.class.should == Class
      CurrencyMutualCredit::XGFL.chop.should == IO.read(XGFLDir+'/mutual_credit.xgfl')
    end
    it "should load Currency class variable with the loaded classes" do
      Currency.types.should == ['CurrencyMutualCredit']
    end
    it "should be able to list a human friend version for creating HTML selects" do
      Currency.types_list.should == [['Mutual Credit','CurrencyMutualCredit']]
    end
  end
  describe "API" do
    before(:each) do
      @c = Currency.create!(@valid_attributes)
    end
    
    it "should provide a url to an icon to represent the currency" do
      @c.api_icon.should == "/images/my_currency.gif"
    end
    it "should provide a symbol to represent the currency" do
      @c.api_symbol.should == 'MC'
    end
    it "should provide a text name for the currency" do
      @c.api_name.should == "My Currency"
    end
  end
end
