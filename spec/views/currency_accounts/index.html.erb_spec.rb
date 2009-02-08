require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/currency_accounts/index.html.erb" do
  include CurrencyAccountsHelper
  
  before(:each) do
    assigns[:currency_accounts] = [
      stub_model(CurrencyAccount,
        :user_id => 1,
        :currency_id => 1,
        :summary => "value for summary"
      ),
      stub_model(CurrencyAccount,
        :user_id => 1,
        :currency_id => 1,
        :summary => "value for summary"
      )
    ]
  end

  it "should render list of currency_accounts" do
    render "/currency_accounts/index.html.erb"
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", "value for summary".to_s, 2)
  end
end

