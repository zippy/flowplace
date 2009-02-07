require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/activities/edit.html.erb" do
  include ActivitiesHelper
  
  before(:each) do
    assigns[:activity] = @activity = stub_model(Activity,
      :new_record? => false,
      :user_id => 1,
      :type => "value for type",
      :activityable_type => "value for activityable_type",
      :activityable_id => 1,
      :contents => "value for contents"
    )
  end

  it "should render edit form" do
    render "/activities/edit.html.erb"
    
    response.should have_tag("form[action=#{activity_path(@activity)}][method=post]") do
      with_tag('input#activity_user_id[name=?]', "activity[user_id]")
      with_tag('input#activity_type[name=?]', "activity[type]")
      with_tag('input#activity_activityable_type[name=?]', "activity[activityable_type]")
      with_tag('input#activity_activityable_id[name=?]', "activity[activityable_id]")
      with_tag('textarea#activity_contents[name=?]', "activity[contents]")
    end
  end
end


