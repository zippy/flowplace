require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe McLib do
  describe "#load_dna" do
    describe "base class" do
      before do
        @dna = McLib.load_dna( :mc_sol )
      end

      it "loads breaths" do
        @dna[:breath].should == [
          Breath::Namasca, Breath::Namaste,Breath::WhoAreYou
        ]
      end
    
      it "loads substrate" do
        @dna[:substrate].should == Substrate::McSol
      end
    
      it "loads transforms" do
        @dna[:transform].should == [
          Transform::Breather, Transform::Namasca, 
          Transform::Namaste
        ]
      end
    end
  end
  
  describe "#classes_for" do
    it "should load from files" do
      McLib.send(:classes_for, :mc_sol, :breath).should == [
        Breath::Namasca, Breath::Namaste,Breath::WhoAreYou
      ]
    end
  end
end