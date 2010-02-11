require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe McLib do
  describe "#load_dna" do
    describe "base class" do
      before do
        @dna = McLib.load_dna( :mc_sol )
      end

      it "loads breaths" do
        @dna[:breath].should == [
          Breath::Base, Breath::Namasca, Breath::Namaste
        ]
      end
    
      it "loads substrate" do
        @dna[:substrate].should == [Substrate::Base]
      end
    
      it "loads transforms" do
        @dna[:transform].should == [
          Transform::Base, Transform::Breather, Transform::Namasca, 
          Transform::Namaste
        ]
      end
    end
  end
  
  describe "#classes_for" do
    it "should load some files" do
      McLib.send(:classes_for, :mc_sol, :breath).should == [
        Breath::Base, Breath::Namasca, Breath::Namaste
      ]
    end
  end
end