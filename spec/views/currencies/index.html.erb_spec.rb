require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/currencies/index.html.erb" do
  include CurrenciesHelper
  
  before(:each) do
    assigns[:currencies] = [
      stub_model(Currency,
        :name => "value for name"
      ),
      stub_model(Currency,
        :name => "value for name"
      )
    ]
  end

  it "should render list of currencies" do
    render "/currencies/index.html.erb"
    response.should have_tag("tr>td", "value for name".to_s, 2)
  end
end

