require 'spec_helper'

describe "/annotations/show.html.erb" do
  include AnnotationsHelper
  before(:each) do
    assigns[:annotation] = @annotation = stub_model(Annotation,
      :body => "value for body",
      :path => "value for path"
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/value\ for\ body/)
    response.should have_text(/value\ for\ path/)
  end
end
