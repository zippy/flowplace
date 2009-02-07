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
    
  
end
