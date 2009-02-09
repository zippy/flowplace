require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/weals/new.html.erb" do
  include WealsHelper
  
  before(:each) do
    assigns[:weal] = stub_model(Weal,
      :new_record? => true,
      :title => "value for title",
      :phase => "value for phase",
      :description => "value for description",
      :requester_id => 1,
      :offerer_id => 1
    )
  end

  it "should render new form" do
    render "/weals/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", weals_path) do
      with_tag("input#weal_title[name=?]", "weal[title]")
      with_tag("input#weal_phase[name=?]", "weal[phase]")
      with_tag("textarea#weal_description[name=?]", "weal[description]")
      with_tag("input#weal_requester_id[name=?]", "weal[requester_id]")
      with_tag("input#weal_offerer_id[name=?]", "weal[offerer_id]")
    end
  end
end


