require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/proposals/edit.html.erb" do
  include ProposalsHelper
  
  before(:each) do
    assigns[:proposal] = @proposal = stub_model(Proposal,
      :new_record? => false,
      :user_id => 1,
      :description => "value for description",
      :as => "value for as",
      :weal_id => 1
    )
  end

  it "should render edit form" do
    render "/proposals/edit.html.erb"
    
    response.should have_tag("form[action=#{proposal_path(@proposal)}][method=post]") do
      with_tag('input#proposal_user_id[name=?]', "proposal[user_id]")
      with_tag('textarea#proposal_description[name=?]', "proposal[description]")
      with_tag('input#proposal_as[name=?]', "proposal[as]")
      with_tag('input#proposal_weal_id[name=?]', "proposal[weal_id]")
    end
  end
end


