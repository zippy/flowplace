require 'spec_helper'

describe "/annotations/edit.html.erb" do
  include AnnotationsHelper

  before(:each) do
    assigns[:annotation] = @annotation = stub_model(Annotation,
      :new_record? => false,
      :body => "value for body",
      :path => "value for path"
    )
  end

  it "renders the edit annotation form" do
    render

    response.should have_tag("form[action=#{annotation_path(@annotation)}][method=post]") do
      with_tag('textarea#annotation_body[name=?]', "annotation[body]")
      with_tag('input#annotation_path[name=?]', "annotation[path]")
    end
  end
end
