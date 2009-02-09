require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/weals/show.html.erb" do
  include WealsHelper
  before(:each) do
    assigns[:weal] = @weal = stub_model(Weal,
      :title => "value for title",
      :phase => "value for phase",
      :description => "value for description",
      :requester_id => 1,
      :offerer_id => 1
    )
  end

  it "should render attributes in <p>" do
    render "/weals/show.html.erb"
    response.should have_text(/value\ for\ title/)
    response.should have_text(/value\ for\ phase/)
    response.should have_text(/value\ for\ description/)
    response.should have_text(/1/)
    response.should have_text(/1/)
  end
end

