require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Weal do
  before(:each) do
    @valid_attributes = {
      :title => "value for title",
      :description => "value for description",
      :requester_id => 1,
      :fulfiller_id => 1
    }
  end
  
  def create_user(user='user')
    u = User.new({:user_name => user, :first_name => 'Joe',:last_name => user.capitalize,:email=>"#{user}@#{user}.org"})
    u.create_bolt_identity(:user_name => :user_name,:password => 'password') && u.save
    u
  end
  
  it "should create a new instance given valid attributes" do
    w  = Weal.create!(@valid_attributes)
    w.should be_an_instance_of(Weal)
    w.phase.should == 'intention'
  end

  it "should fail to create a new instance without a tile" do
    @valid_attributes.delete(:title)
    lambda {Weal.create!(@valid_attributes)}.should raise_error("Validation failed: Title can't be blank")
  end

  it "should fail to create a new instance without a requester or fulfiller" do
    @valid_attributes.delete(:requester_id)
    @valid_attributes.delete(:fulfiller_id)
    lambda {Weal.create!(@valid_attributes)}.should raise_error(ActiveRecord::RecordInvalid,"Validation failed: Must have a requester or fulfiller")
  end
  
  it "should be able to report who created it" do
    @user = create_user
    @weal  = Weal.create!(:title => "title",:requester_id=>@user.id)
    @weal.created_by.should == @user
  end
  
  it "should have a matched? method to report if the intention is matched" do
    @user = create_user
    @weal  = Weal.create!(:title => "title",:requester_id=>@user.id)
    @weal.should_not be_matched
    @user = create_user('x')
    @weal.fulfiller_id = @user.id
    @weal.should be_matched
  end
  
end
