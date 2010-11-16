require 'spec_helper'

describe "/annotations/index.html.erb" do
  include AnnotationsHelper

  before(:each) do
    assigns[:annotations] = [
      stub_model(Annotation,
        :body => "value for body",
        :path => "value for path"
      ),
      stub_model(Annotation,
        :body => "value for body",
        :path => "value for path"
      )
    ]
  end

  it "renders a list of annotations" do
    render
    response.should have_tag("tr>td", "value for body".to_s, 2)
    response.should have_tag("tr>td", "value for path".to_s, 2)
  end
end
