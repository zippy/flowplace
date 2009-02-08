require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CurrencyAccount do
  before(:each) do
    @valid_attributes = {
      :user_id => 1,
      :currency_id => 1,
      :summary => "value for summary"
    }
  end

  it "should create a new instance given valid attributes" do
    CurrencyAccount.create!(@valid_attributes)
  end
end
