require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

=begin

describe SolLink do 
  describe "new" do
    before do
      # FIXME: need a linkable_sol to play with
      # where do we get the link_key ?
      @sol_link = SolLink.new( linkable_sol, link_key )
    end

    it "returns instance for key" do
      @sol_link.should be_instance_of( SolLink )
    end

    it "can execute breaths" do
      @sol_link.exhale "MC Sol", :I_am
    end
  end
end

=end
