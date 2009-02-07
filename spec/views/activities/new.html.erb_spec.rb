require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/activities/new.html.erb" do
  include ActivitiesHelper
  
  before(:each) do
    assigns[:activity] = stub_model(Activity,
      :new_record? => true,
      :user_id => 1,
      :type => "value for type",
      :activityable_type => "value for activityable_type",
      :activityable_id => 1,
      :contents => "value for contents"
    )
  end

  it "should render new form" do
    render "/activities/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", activities_path) do
      with_tag("input#activity_user_id[name=?]", "activity[user_id]")
      with_tag("input#activity_type[name=?]", "activity[type]")
      with_tag("input#activity_activityable_type[name=?]", "activity[activityable_type]")
      with_tag("input#activity_activityable_id[name=?]", "activity[activityable_id]")
      with_tag("textarea#activity_contents[name=?]", "activity[contents]")
    end
  end
end


