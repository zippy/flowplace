require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/activities/show.html.erb" do
  include ActivitiesHelper
  before(:each) do
    assigns[:activity] = @activity = stub_model(Activity,
      :user_id => 1,
      :type => "value for type",
      :activityable_type => "value for activityable_type",
      :activityable_id => 1,
      :contents => "value for contents"
    )
  end

  it "should render attributes in <p>" do
    render "/activities/show.html.erb"
    response.should have_text(/1/)
    response.should have_text(/value\ for\ type/)
    response.should have_text(/value\ for\ activityable_type/)
    response.should have_text(/1/)
    response.should have_text(/value\ for\ contents/)
  end
end

