require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/circles/index.html.erb" do
  include CirclesHelper
  
  before(:each) do
    assigns[:circles] = [
      stub_model(Circle,
        :name => "value for name"
      ),
      stub_model(Circle,
        :name => "value for name"
      )
    ]
  end

  it "should render list of circles" do
    render "/circles/index.html.erb"
    response.should have_tag("tr>td", "value for name".to_s, 2)
  end
end

