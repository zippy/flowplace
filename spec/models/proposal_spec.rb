require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Proposal do
  before(:each) do
    @valid_attributes = {
      :user_id => 1,
      :description => "value for description",
      :as => "value for as",
      :weal_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    Proposal.create!(@valid_attributes)
  end
  it "should fail to create a new instance without a user" do
    @valid_attributes.delete(:user_id)
    lambda {Proposal.create!(@valid_attributes)}.should raise_error("Validation failed: User can't be blank")
  end
  it "should fail to create a new instance without a weal" do
    @valid_attributes.delete(:weal_id)
    lambda {Proposal.create!(@valid_attributes)}.should raise_error("Validation failed: Weal can't be blank")
  end
  it "should fail to create a new instance without specifying as" do
    @valid_attributes.delete(:as)
    lambda {Proposal.create!(@valid_attributes)}.should raise_error("Validation failed: As can't be blank")
  end

end
