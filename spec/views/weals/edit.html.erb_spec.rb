require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/weals/edit.html.erb" do
  include WealsHelper
  
  before(:each) do
    assigns[:weal] = @weal = stub_model(Weal,
      :new_record? => false,
      :title => "value for title",
      :phase => "value for phase",
      :description => "value for description",
      :requester_id => 1,
      :fulfiller_id => 1
    )
  end

  it "should render edit form" do
    render "/weals/edit.html.erb"
    
    response.should have_tag("form[action=#{weal_path(@weal)}][method=post]") do
      with_tag('input#weal_title[name=?]', "weal[title]")
      with_tag('input#weal_phase[name=?]', "weal[phase]")
      with_tag('textarea#weal_description[name=?]', "weal[description]")
      with_tag('input#weal_requester_id[name=?]', "weal[requester_id]")
      with_tag('input#weal_fulfiller_id[name=?]', "weal[fulfiller_id]")
    end
  end
end


