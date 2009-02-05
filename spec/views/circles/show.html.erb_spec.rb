require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/circles/show.html.erb" do
  include CirclesHelper
  before(:each) do
    assigns[:circle] = @circle = stub_model(Circle,
      :name => "value for name"
    )
  end

  it "should render attributes in <p>" do
    render "/circles/show.html.erb"
    response.should have_text(/value\ for\ name/)
  end
end

