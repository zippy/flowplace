require 'spec_helper'

describe "/annotations/new.html.erb" do
  include AnnotationsHelper

  before(:each) do
    assigns[:annotation] = stub_model(Annotation,
      :new_record? => true,
      :body => "value for body",
      :path => "value for path"
    )
  end

  it "renders new annotation form" do
    render

    response.should have_tag("form[action=?][method=post]", annotations_path) do
      with_tag("textarea#annotation_body[name=?]", "annotation[body]")
      with_tag("input#annotation_path[name=?]", "annotation[path]")
    end
  end
end
