require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CurrenciesHelper do
  
  describe "humanized_currency_scope" do
    it "should return the Global if the currency is global and is not limitted to a circle" do
      c = create_currency("Test",:global=>true)
      helper.humanized_currency_scope(c).should == 'Global'
    end
    it "should return the circle name if the currency is limitted to a circle" do
      circ = Circle.create!(:name=>"Circle")
      c = create_currency("Test",:circle_id=>circ.id)
      helper.humanized_currency_scope(c).should == 'Circle'
    end
    it "should return the circle name + global if the currency is from a circle but is globally available" do
      circ = Circle.create!(:name=>"Circle")
      c = create_currency("Test",:circle_id=>circ.id,:global => true)
      helper.humanized_currency_scope(c).should == 'Circle--Global'
    end
  end
  
end
