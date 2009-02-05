require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/circles/edit.html.erb" do
  include CirclesHelper
  
  before(:each) do
    assigns[:circle] = @circle = stub_model(Circle,
      :new_record? => false,
      :name => "value for name"
    )
  end

  it "should render edit form" do
    render "/circles/edit.html.erb"
    
    response.should have_tag("form[action=#{circle_path(@circle)}][method=post]") do
      with_tag('input#circle_name[name=?]', "circle[name]")
    end
  end
end


