require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Play do
  before(:each) do
    @valid_attributes = {
      :currency_account_id => 1,
      :content => "some play data"
    }
  end

  it "should create a new instance given valid attributes" do
    Play.create!(@valid_attributes)
  end

  it "should raise an error given no currency account" do
    lambda {Play.create!}.should raise_error
  end

  it "should return the currency account " do
    u = create_user
    c = create_currency("Currency")
    ca = CurrencyAccount.create!(:user_id => u.id,:currency_id=>c.id,:name=>'my_account',:player_class=>'member')
    p = Play.create!(:currency_account_id => ca.id,:content => 'play content')
    p.currency_account.should == ca
  end
  
end
