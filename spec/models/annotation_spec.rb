require 'spec_helper'

describe Annotation do
  before(:each) do
    @valid_attributes = {
      :body => "value for body",
      :path => "value for path"
    }
  end

  it "should create a new instance given valid attributes" do
    Annotation.create!(@valid_attributes)
  end
end
