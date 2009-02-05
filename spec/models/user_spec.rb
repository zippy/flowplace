require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do
  before(:each) do
    @valid_attributes = {
      :first_name => "value for first_name",
      :last_name => "value for last_name",
      :last_name => "some@email.com"
    }
  end

  it "should create a new instance given valid attributes" do
    User.create!(@valid_attributes)
  end
  
  def create_user(user='user')
    u = User.new({:user_name => user, :first_name => 'Joe',:last_name => user.capitalize,:email=>"#{user}@#{user}.org"})
    u.create_bolt_identity(:user_name => :user_name,:password => 'password') && u.save
    u
  end
  
  describe 'retreiving weals' do
    before(:each) do
      @user = create_user
      @weal  = Weal.create!(:title => "title",:requester_id=>@user.id)
      @wealf = Weal.create!(:title => "title2",:fulfiller_id=>@user.id)
      @wealx = Weal.create!(:title => "title3",:requester_id=>999)
    end
    
    it "should be able to return a list of its requester weals" do
      @user.weals_as_requester.should == [@weal]
    end

    it "should be able to return a list of its fulfiller weals" do
      @user.weals_as_fulfiller.should == [@wealf]
    end
    
    it "should be able to return a list of its weals" do
      @user.weals.should == [@weal,@wealf]
    end

  end
  
end
