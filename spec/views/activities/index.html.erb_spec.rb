require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/activities/index.html.erb" do
  include ActivitiesHelper
  
  before(:each) do
    assigns[:activities] = [
      stub_model(Activity,
        :user_id => 1,
        :type => "value for type",
        :activityable_type => "value for activityable_type",
        :activityable_id => 1,
        :contents => "value for contents"
      ),
      stub_model(Activity,
        :user_id => 1,
        :type => "value for type",
        :activityable_type => "value for activityable_type",
        :activityable_id => 1,
        :contents => "value for contents"
      )
    ]
  end

  it "should render list of activities" do
    render "/activities/index.html.erb"
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", "value for type".to_s, 2)
    response.should have_tag("tr>td", "value for activityable_type".to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", "value for contents".to_s, 2)
  end
end

