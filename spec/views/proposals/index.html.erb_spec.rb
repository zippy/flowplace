require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/proposals/index.html.erb" do
  include ProposalsHelper
  
  before(:each) do
    assigns[:proposals] = [
      stub_model(Proposal,
        :user_id => 1,
        :description => "value for description",
        :as => "value for as",
        :weal_id => 1
      ),
      stub_model(Proposal,
        :user_id => 1,
        :description => "value for description",
        :as => "value for as",
        :weal_id => 1
      )
    ]
  end

  it "should render list of proposals" do
    render "/proposals/index.html.erb"
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", "value for description".to_s, 2)
    response.should have_tag("tr>td", "value for as".to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
  end
end

