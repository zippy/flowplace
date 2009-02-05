require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/currencies/new.html.erb" do
  include CurrenciesHelper
  
  before(:each) do
    assigns[:currency] = stub_model(Currency,
      :new_record? => true,
      :name => "value for name"
    )
  end

  it "should render new form" do
    render "/currencies/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", currencies_path) do
      with_tag("input#currency_name[name=?]", "currency[name]")
    end
  end
end


