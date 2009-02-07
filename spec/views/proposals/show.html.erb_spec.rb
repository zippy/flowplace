require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/proposals/show.html.erb" do
  include ProposalsHelper
  before(:each) do
    assigns[:proposal] = @proposal = stub_model(Proposal,
      :user_id => 1,
      :description => "value for description",
      :as => "value for as",
      :weal_id => 1
    )
  end

  it "should render attributes in <p>" do
    render "/proposals/show.html.erb"
    response.should have_text(/1/)
    response.should have_text(/value\ for\ description/)
    response.should have_text(/value\ for\ as/)
    response.should have_text(/1/)
  end
end

