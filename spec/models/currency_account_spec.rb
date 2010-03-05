require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CurrencyAccount do
  before(:each) do
    @valid_attributes = {
      :user_id => 1,
      :name => 'my account',
      :currency_id => 1,
      :player_class => "member"
    }
  end

  it "should create a new instance given valid attributes" do
    CurrencyAccount.create!(@valid_attributes)
  end
  
  it "should be able to report a name suitable for use as an html id" do
    a = CurrencyAccount.create!(@valid_attributes)
    a.name_as_html_id.should == 'my_account'
  end

  it "should not create a duplicate account for the same account name, player_class and currency" do
    CurrencyAccount.create!(@valid_attributes)
    lambda {CurrencyAccount.create!(@valid_attributes)}.should raise_error
    x = @valid_attributes
    x[:player_class] = "admin"
    lambda {CurrencyAccount.create!(x)}.should_not raise_error
    x = @valid_attributes
    x[:currency_id] = 2
    lambda {CurrencyAccount.create!(x)}.should_not raise_error
    x = @valid_attributes
    x[:name] = "account2"
    lambda {CurrencyAccount.create!(x)}.should_not raise_error
  end

  describe "valid accounts" do
    before(:each) do
      @user = create_user('u1')
      @currency = create_currency("LETS",:klass=>CurrencyMutualCredit)
      @account = create_currency_account(@user,@currency)
    end
    it "should not create an account with an invalid player class" do
      ca = CurrencyAccount.new(:user_id => @user.id,:name => 'u1',:currency_id => @currency.id,:player_class => 'doggy')
      ca.save.should == false
      ca.errors.full_messages.should == ['Player class doggy does not exist in LETS']
    end
    it "should be able to render the account state" do
      @account.render_state.should == "Balance: 0<br/>Volume: 0"
    end
    it "should get the state of an account" do
      @account.get_state.should == {'balance' => 0, 'volume' => 0}
      ca = CurrencyAccount.find(@account.id)
      ca.get_state.should == {'balance' => 0, 'volume' => 0}
    end
  end
  
  describe "account history" do
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
    it "return a list of plays the account was involved in" do
      all_plays = Play.find(:all)
      @account.plays.should == all_plays
      @account2.plays.should == [all_plays.first]
      @account3.plays.should == [all_plays.last]
    end    
  end
end
