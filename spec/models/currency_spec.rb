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
    @c = Currency.new(@valid_attributes)
    @c.type = 'CurrencyMutualCredit'
  end

  it "should create a new instance given valid attributes" do
    @c.save!
  end

  it "should raise an error given no name attribute" do
    @c.name = nil
    lambda {@c.save!}.should raise_error
  end

  it "should raise an error given no type attribute" do
    @c.type = nil
    lambda {@c.save!}.should raise_error
  end
  
  it "should be able to report a name suitable for use as an html id" do
    @c.save!
    @c.name_as_html_id.should == 'my_currency'
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
  
  describe "config" do
    before(:each) do
      @user = create_user('u1')
      @currency = create_currency("R1",:klass=>CurrencyMutualRating)
      @account = create_currency_account(@user,@currency)
      @configuration = {'rate.rating' => 'good,bad,ugly'}
    end
    
    it "an unititialized configuration should return nil" do
      @currency.configuration.should == nil
    end

    it "should automatically serialize and unserialize the configuration" do
      @currency.configuration = @configuration
      @currency.configuration.should == @configuration
      @currency.config.should == @configuration
      @currency.save
      c = Currency.find_by_name('R1')
      c.config.should == @configuration.to_yaml
      c.configuration.should == @configuration
    end
#    describe "MutualRating"
  end
  
  describe "API" do
    before(:each) do
      @c.save!
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
      state = @currency.api_initialize_new_player_state('member')
      state.should == {'balance' => 0, 'volume' => 0}
    end
    it "should be able to create a new player with default name from the user" do
      @user2 = create_user('u2')
      ca = @currency.api_new_player('member',@user2)
      ca.class.should == CurrencyAccount
      ca.currency.should == @currency
      ca.name.should == 'u2'
    end
    it "should be able to create a new player with a specified name" do
      @user2 = create_user('u2')
      ca = @currency.api_new_player('member',@user2,'x')
      ca.class.should == CurrencyAccount
      ca.currency.should == @currency
      ca.name.should == 'x'
    end
    it "should be able to render the account state" do
      @currency.api_render_player_state(@account).should == "Balance: 0; Volume: 0"
    end
    it "should be able to return state fields for a player_class" do
      @currency.api_state_fields('member').should == [{"balance"=>"integer"}, {"volume"=>"integer"}]
    end
    it "should be able to return the fields for a play" do
      @currency.api_play_fields('pay').should == [
        {"from"=>{'id'=>'from','type'=>"player_member"}}, {"to"=>{'id'=>'to','type'=>"player_member"}}, {"aggregator"=>{'id'=>'aggregator','type'=>"player_aggregator"}}, {"amount"=>{'id'=>'amount','type'=>"integer"}}, {"memo"=>{'id'=>'memo','type'=>"string"}}
        ]
    end
    it "should be able to return a list of the configurable fields" do
      @cr = create_currency("R1",:klass=>CurrencyMutualRating)
      @cr.api_configurable_fields.should == {"rate.rating"=>"enumerable_range", "rate.rating.default"=>"poor,average,good,excellent"}
    end
    it "should be able to return a list of player classes" do
      @currency.api_player_classes.should == ['member','aggregator','admin']
    end
    it "should be able to return a the play sentence" do
      @currency.api_play_sentence('pay').should == "<from/> pays <to/> <amount/> for <memo/>"
    end
    it "should be able to return a list of plays" do
      @currency.api_plays.should == {"_new_member"=>{:player_classes=>""}, "reverse"=>{:player_classes=>"admin"}, "pay"=>{:player_classes=>"member"}, "_new_aggregator"=>{:player_classes=>""}}
    end
    it "should be able to return the game description" do
      @currency.api_description.should == "\n    Mutual credit currencies are a \"means of exchange\" currency where all members issue currency at the point of transaction.<br/>\n    Player classes: member<br/>\n    Summary function: Balance,Volume<br/>\n    Member Plays: Pay(to,amount,memo)<br/>\n  "
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
    it "should be able to answer if a user is a given player class in the currency" do
      @account2 = create_currency_account(@user,@currency,'admin')
      @currency.api_user_accounts(@user,'member').should == [@account]
      @currency.api_user_accounts(@user,'admin').should == [@account2]
      @currency.api_user_isa?(@user,'member').should == true
      @currency.api_user_isa?(@user,'admin').should == true
      @currency.api_user_isa?(@user,'fish').should == false
      @user2 = create_user('u2')
      @currency.api_user_isa?(@user2,'member').should == false
      @currency.api_user_accounts(@user2,'member').should == []
    end
    describe 'utilities' do
      it "get_play_script should return the script of the named play" do
        @currency.get_play_script('pay').should == "\n        @play.from['balance'] -= @play.amount\n        @play.from['volume'] += @play.amount.abs\n        @play.to['balance'] += @play.amount\n        @play.to['volume'] += @play.amount.abs\n        @play.aggregator['volume'] += @play.amount.abs if @play.aggregator\n        true\n        "
      end
    end
  end
end
