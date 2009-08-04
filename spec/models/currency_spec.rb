require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Currency do
  
  describe Currency::State do
    it "should be initializable with an array of state names" do
      s = Currency::State.new(['a','b'])
      s.get_state.should == {'a'=>nil,'b'=>nil}
    end
    it "should be able to set a state as if it were a method" do
      s = Currency::State.new(['a','b'])
      s.a= 1
      s.a.should == 1
    end
    it "should be able to set a state as if it were a hash" do
      s = Currency::State.new(['a','b'])
      s['a'] = 1
      s['a'].should == 1
    end
    it "should raise an error for a state that was not declared at initialization" do
      s = Currency::State.new(['a','b'])
      lambda {s.c}.should raise_error
    end
  end
  
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
      CurrencyMutualCredit.new.xgfl.chop.should == IO.read(XGFLDir+'/mutual_credit.xgfl')
    end
    it "should load Currency class variable with the loaded classes" do
      Currency.types.include?("CurrencyMutualCredit").should == true
    end
    it "should be able to humanize a type" do
      Currency.humanize_type('CurrencyMutualCredit').should == 'Mutual Credit'
    end
  end
  
  describe "relations" do
    before(:each) do
      @usd = create_currency("USD",:klass=>CurrencyIssued)
      @user1 = create_user('u1')
      @user2 = create_user('u2')
      @user3 = create_user('u3')
      @account1 = create_currency_account(@user1,@usd)
      @account2 = create_currency_account(@user2,@usd)
    end

    it "should have many users" do
      @usd.users.include?(@user1).should == true
      @usd.users.include?(@user2).should == true
      @usd.users.include?(@user3).should == false
    end
    it "should have many currency_accounts" do
      @usd.currency_accounts.include?(@account1).should == true
      @usd.currency_accounts.include?(@account2).should == true
    end
  end
  
  describe "API" do
    before(:each) do
      @c = Currency.create!(@valid_attributes)
      @user = create_user('u1')
      @currency = create_currency("LETS",:klass=>CurrencyMutualCredit)
      @account = create_currency_account(@user,@currency)
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
    it "should be able to initialize a player state" do
      state = @currency.api_new_player('member')
      state.should == {'balance' => 0, 'volume' => 0}
    end
    it "should be able to render the account state" do
      @currency.api_render_account_state(@account).should == "Balance: 0; Volume: 0"
    end
    it "should be able to return state fields for a player_class" do
      @currency.api_state_fields('member').should == [{"balance"=>"integer"}, {"volume"=>"integer"}]
    end
    it "should be able to return the fields for a play" do
      @currency.api_play_fields('pay').should == [{"from"=>"player_member"}, {"to"=>"player_member"}, {"aggregator"=>"player_aggregator"}, {"amount"=>"integer"}, {"memo"=>"text"}]
    end
    it "should be able to return a list of player classes" do
      @currency.api_player_classes.should == ['member','aggregator']
    end
    it "should be able to return a list of plays" do
      @currency.api_plays.should == {"_new_member"=>{:player_classes=>""}, "reversal"=>{:player_classes=>"member"}, "pay"=>{:player_classes=>"member"}, "_new_aggregator"=>{:player_classes=>""}}
    end
    it "should be able to record a play" do
      @user2 = create_user('u2')
      @account2 = create_currency_account(@user2,@currency)
      play = {'from' => @account, 'to' => @account2, 'amount'=>20, 'memo'=>'leg waxing'}
      @account.get_state['balance'].should == 0
      @account2.get_state['balance'].should == 0
      Play.find(:all).size.should == 0
      @currency.api_play('pay',@account,play)
      @account.get_state['balance'].should == -20
      @account2.get_state['balance'].should == 20
      plays = Play.find(:all)
      plays.size.should == 1
    end
    describe 'utilities' do
      it "get_play_script should return the script of the named play" do
        @currency.get_play_script('pay').should == "\n        @from.member_state.balance -= @amount\n        @from.member_state.volume += abs(@amount)\n        @to.member_state.balance += @amount\n        @to.member_state.volume += abs(@amount)\n        @aggregator.aggregator_state.volume += abs(@amount)\n        "
      end
    end
  end
end
