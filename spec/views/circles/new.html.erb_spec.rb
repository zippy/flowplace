require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/circles/new.html.erb" do
  include CirclesHelper
  
  before(:each) do
    assigns[:circle] = stub_model(Circle,
      :new_record? => true,
      :name => "value for name"
    )
  end

  it "should render new form" do
    render "/circles/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", circles_path) do
      with_tag("input#circle_name[name=?]", "circle[name]")
    end
  end
end


