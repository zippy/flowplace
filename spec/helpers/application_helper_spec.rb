require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ApplicationHelper do
  describe "currencies_list_for_select" do
    it "should return a list of name/id pairs for building currency selects" do
      c1 = create_currency('Currency 1')
      c2 = create_currency('Currency 2')
      helper.currencies_list_for_select([c1,c2]).should == [['Currency 1',c1.id],['Currency 2',c2.id]]
    end
  end
end