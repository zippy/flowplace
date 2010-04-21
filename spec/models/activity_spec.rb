require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Activity do
  describe IntentionActivity do
    before(:each) do
      @user = create_user
      @weal  = Weal.create!(:title => "title",:requester_id=>@user.id)
    end
    it "should create a valid activity" do
      a = IntentionActivity.add(@user,@weal,'created')
      a.user_id.should == @user.id
      a.activityable.should == @weal
      a.contents.should == 'created'
      a.id.should_not be_nil
    end
    it "should not create an invalid activity" do
      lambda {IntentionActivity.add(nil,@weal,'created')}.should raise_error("Validation failed: User can't be blank")
      lambda {IntentionActivity.add(@user,nil,'created')}.should raise_error("Validation failed: Activityable can't be blank")
    end
    it "should create a human redable name based on the class name" do
      a = IntentionActivity.add(@user,@weal,'created')
      a.humanize.should=="Intention"
    end
  end
  describe CurrencyActivity do
    before(:each) do
      @currency = create_currency("LETS",:klass=>CurrencyMutualCredit)
      @user1 = create_user('u1')
      @user2 = create_user('u2')
      @account1 = create_currency_account(@user1,@currency)
      @account2 = create_currency_account(@user2,@currency)
      play = {'from' => @account1, 'to' => @account2, 'amount'=>20, 'memo'=>'leg waxing'}
      @play = @currency.api_play('pay',@account1,play)
    end
    it "stores currency activities" do
      a = CurrencyActivity.add(@user1,@currency,{'played'=>@play})
      b = CurrencyActivity.find(:first)
      b.should === a
      b.activityable.should == @currency
      YAML.load(b.contents)['played'].class.should == Play
      @currency.currency_activities[0].should === a
    end
  end
end
