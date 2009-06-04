require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/plays/show.html.erb" do
  include PlaysHelper
  before(:each) do
    assigns[:play] = @play = stub_model(Play,
      :currency_account_id => 1,
      :content => "value for content"
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/1/)
    response.should have_text(/value\ for\ content/)
  end
end

