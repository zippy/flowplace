require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/currencies/edit.html.erb" do
  include CurrenciesHelper
  
  before(:each) do
    assigns[:currency] = @currency = stub_model(Currency,
      :new_record? => false,
      :name => "value for name"
    )
  end

  it "should render edit form" do
    render "/currencies/edit.html.erb"
    
    response.should have_tag("form[action=#{currency_path(@currency)}][method=post]") do
      with_tag('input#currency_name[name=?]', "currency[name]")
    end
  end
end


