require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Play do
  before(:each) do
    @valid_attributes = {
      :content => "some play data"
    }
  end

  it "should create a new instance given valid attributes" do
    Play.create!(@valid_attributes)
  end

  describe "play_currency_account links" do
    before(:each) do
      @user = create_user('u1')
      @user2 = create_user('u2')
      @user3 = create_user('u3')
      @currency = create_currency("LETS",:klass=>CurrencyMutualCredit)
      @account = create_currency_account(@user,@currency)
      @account2 = create_currency_account(@user2,@currency)
      @account3 = create_currency_account(@user3,@currency)
      play = {'from' => @account, 'to' => @account2, 'amount'=>20, 'memo'=>'leg waxing'}
      @currency.api_play('pay',@account,play)
      play = {'from' => @account, 'to' => @account3, 'amount'=>100, 'memo'=>'botox'}
      @currency.api_play('pay',@account,play)
    end
    it "returns a list of currency accounts involved in the play" do
      all_plays = Play.find(:all)
      all_plays.first.currency_accounts.should == [@account,@account2]
      all_plays.last.currency_accounts.should == [@account,@account3]
    end    
  end
end
