require File.dirname(__FILE__) + '/../spec_helper'

describe Configuration do
  before(:each) do
    @configuration = Configuration.new
  end

  it "should be valid" do
    @configuration.should be_valid
  end
  
  it "should be able to load defaults" do
    Configuration.load_defaults
    Configuration.all.size.should == 4
  end
end
