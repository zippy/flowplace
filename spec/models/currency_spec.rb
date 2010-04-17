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
      :created_by => 1,
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

  it "should raise an error given no created_by attribute" do
    @c.created_by = nil
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
      @account1 = create_currency_account(@user1,@usd,'user')
      @account2 = create_currency_account(@user2,@usd,'user')
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
      @cr = create_currency("A1",:klass=>CurrencyAcknowledgement)
      @account = create_currency_account(@user,@currency)
      @configuration = {'rate.rating' => 'good,bad,ugly'}
    end
    
    it "an unititialized configuration should return the defaults" do
      @currency.configuration.should == {"rate.rating"=>"poor,average,good,excellent"}
      @cr.configuration.should == {"acknowledge.ack"=>"1,2,3,4,5", "_.max_per_day"=>20, "_.max_per_person_per_day"=>5}
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
    it "should use default values for unspecified parameters when setting the configuration manually" do
      @currency.configuration = {}
      @currency.configuration['rate.rating'].should == "poor,average,good,excellent"
    end
    it "should cast input values appropriately when setting the configuration" do
      @cr.configuration = {"_.max_per_day" => "20"}
      @cr.configuration['_.max_per_day'].should == 20
    end
#    describe "MutualRating"
  end
  
  describe "membrane currency" do
    before(:each) do
      @user = create_user('u1')
      @circle = CurrencyMembrane.create(@user,{:circle=>{:name => 'a circle',:created_by=>@user.id},:password=>'password',:confirmation=>'password',:email=>'test@test.com'})
    end
    it "should create a circle with associated user and self and namer players" do
      @circle.class.should == CurrencyMembrane
      @circle.errors.should be_empty
      @circle.circle_user_name.should == 'a_circle_circle'
      @circle.api_user_isa?(User.find_by_user_name('a_circle_circle'),'self').should == true
      @circle.api_user_isa?(@user,'namer').should == true
    end
    describe "binding" do
      it "should return a list of currencies bound to the membrane" do
        @mc = create_currency("MC",:klass=>CurrencyMutualCredit)
        @self = User.find_by_user_name('a_circle_circle').currency_accounts[0]
        @namer = @user.currency_accounts[0]
        
        play = {
          'from' => @namer,
          'to' => @self,
          'currency' => @mc
        }
        @self.get_state['currencies'].should == {}
        @circle.currencies.should == []
        @circle.api_play('bind_currency',@namer,play).class.should == Play
        @self.get_state['currencies'].should == {@mc.id => @mc.name}
        @circle.currencies.should == [@mc]
      end
    end
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
    it "should be able to return the fields names a play" do
      @currency.api_play_field_names('pay').should == ["from","to","aggregator","amount","memo"]
    end

    it "should be able to return the play names available to a player class" do
      @currency.api_play_names('member').should == ["pay"]
    end

    describe "configurable fields" do
      it "should be able to return a list of the configurable fields for plays" do
        @cr = create_currency("R1",:klass=>CurrencyMutualRating)
        @cr.api_configurable_fields.should == {"rate.rating"=>"enumerable_range", "rate.rating.default"=>"poor,average,good,excellent"}
      end
      it "should include currency configuration fields" do
        @cr = create_currency("A1",:klass=>CurrencyAcknowledgement)
        @cr.api_configurable_fields.should == {
          "acknowledge.ack"=>"enumerable_range",
          "acknowledge.ack.default"=>"1,2,3,4,5",
          "_.max_per_person_per_day" => "integer",
          "_.max_per_person_per_day.default" => "5",
          "_.max_per_day" => "integer",
          "_.max_per_day.default" => "20"
          }
      end
      it "should initialize the currency state" do
        @cr = create_currency("A1",:klass=>CurrencyAcknowledgement)
        @cr.configuration["_.max_per_day"].should == 20
        @cr.configuration["_.max_per_person_per_day"].should == 5
      end
    end
    it "should be able to return a list of player classes" do
      @currency.api_player_classes.should == ['member','aggregator','admin']
    end
    it "should be able to return a the play sentence as raw html" do
      @currency.api_play_sentence_raw('pay').should == "<from></from> pays <to></to> <amount></amount> for <memo></memo>"
    end
    it "should be able to return a the play sentence as parsed XML" do
      s = @currency.api_play_sentence('pay')
      s.class.should == Nokogiri::XML::Element
      s.name.should == "play_sentence"
    end
    it "should be able to return a list of the fields used in the play sentence" do
      s = @currency.api_play_sentence_fields('pay').should == %w(from to amount memo)
    end
    
    it "should be able to return a list of plays" do
      @currency.api_plays.should == {"_new_member"=>{:player_classes=>""}, "reverse"=>{:player_classes=>"admin"}, "pay"=>{:player_classes=>"member"}, "_new_aggregator"=>{:player_classes=>""}}
    end
    it "should be able to return the game description" do
      @currency.api_description.should == "\n    Mutual credit currencies are a \"means of exchange\" currency where all members issue currency at the point of transaction.<br>\n    Player classes: member<br>\n    Summary function: Balance,Volume<br>\n    Member Plays: Pay(to,amount,memo)<br>\n  "
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
    
    it "returns the play history for an account" do
      @user2 = create_user('u2')
      @account2 = create_currency_account(@user2,@currency)
      play = {'from' => @account, 'to' => @account2, 'amount'=>20, 'memo'=>'leg waxing'}
      @currency.api_play('pay',@account,play)
      history = @currency.api_play_history(@account)
      history.size.should == 1
      h = history[0]
      t = h["__meta"].delete("timestamp")
      h.should == { "__meta" => {"name"=>"pay"}, "from"=>{"_name"=>"Joe U1", "volume"=>20, "balance"=>-20}, "amount"=>20, "memo"=>"leg waxing", "to"=>{"_name"=>"Joe U2", "volume"=>20, "balance"=>20}, "aggregator"=>nil}
    end
    
    describe 'api_user_accounts' do
      before(:each) do
        @account2 = create_currency_account(@user,@currency,'admin')
        @user2 = create_user('u2')
      end
      it "should be able to return a list of all the accounts of a given player class in a currency" do
        @account3 = create_currency_account(@user2,@currency,'member')
        @currency.api_user_accounts('admin').should == [@account2]
        accounts = @currency.api_user_accounts('member')
        accounts.should == [@account,@account3]
        accounts = @currency.api_user_accounts('admin')
        accounts.should == [@account2]
      end
      it "should be able to answer if a user is a given player class in the currency" do
        @currency.api_user_accounts('member',@user).should == [@account]
        @currency.api_user_accounts('admin',@user).should == [@account2]
        @currency.api_user_isa?(@user,'member').should == true
        @currency.api_user_isa?(@user,'admin').should == true
        @currency.api_user_isa?(@user,'fish').should == false
        @currency.api_user_isa?(@user2,'member').should == false
        @currency.api_user_accounts('member',@user2).should == []
      end
    end
    describe 'utilities' do
      it "get_play_script should return the script of the named play" do
        @currency.get_play_script('pay').should == "\n        @play.from['balance'] -= @play.amount\n        @play.from['volume'] += @play.amount.abs\n        @play.to['balance'] += @play.amount\n        @play.to['volume'] += @play.amount.abs\n        @play.aggregator['volume'] += @play.amount.abs if @play.aggregator\n        true\n        "
      end
    end
  end
end
