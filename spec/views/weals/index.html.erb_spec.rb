require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/weals/index.html.erb" do
  include WealsHelper
  
  before(:each) do
    assigns[:weals] = [
      stub_model(Weal,
        :title => "value for title",
        :phase => "value for phase",
        :description => "value for description",
        :requester_id => 1,
        :offerer_id => 1
      ),
      stub_model(Weal,
        :title => "value for title",
        :phase => "value for phase",
        :description => "value for description",
        :requester_id => 1,
        :offerer_id => 1
      )
    ]
  end

  it "should render list of weals" do
    render "/weals/index.html.erb"
    response.should have_tag("tr>td", "value for title".to_s, 2)
    response.should have_tag("tr>td", "value for phase".to_s, 2)
    response.should have_tag("tr>td", "value for description".to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
  end
end

