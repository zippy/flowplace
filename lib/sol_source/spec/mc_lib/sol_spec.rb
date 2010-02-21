require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Sol do
  describe "after bootstrap" do
    before do
      # run bootstrap process
      @mc_sol = Sol.new "MC Sol", McLib.load_dna( :mc_sol )
      Network.register @mc_sol
    end

    it "MC Sol responds to namaste breaths" do
      # create local copy of mc sol to test against MC
      @test_sol = Sol.new "Test Sol", McLib.load_dna('mc_sol')
      Network.register @test_sol
      
      @mc_sol.should_receive(:inhale).with( instance_of(Breath::Namaste) )
      @test_sol.exhale "MC Sol", :namaste
    end
  end

  # pending
  describe "I_am" do
    it "returns Sol and private key" do
      pending
      sol, private_key = Sol.I_am 
    end
  end
end

