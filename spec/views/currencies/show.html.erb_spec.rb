require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/currencies/show.html.erb" do
  include CurrenciesHelper
  before(:each) do
    assigns[:currency] = @currency = stub_model(Currency,
      :name => "value for name"
    )
  end

  it "should render attributes in <p>" do
    render "/currencies/show.html.erb"
    response.should have_text(/value\ for\ name/)
  end
end

