require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/currency_accounts/show.html.erb" do
  include CurrencyAccountsHelper
  before(:each) do
    assigns[:currency_account] = @currency_account = stub_model(CurrencyAccount,
      :user_id => 1,
      :currency_id => 1,
      :summary => "value for summary"
    )
  end

  it "should render attributes in <p>" do
    render "/currency_accounts/show.html.erb"
    response.should have_text(/1/)
    response.should have_text(/1/)
    response.should have_text(/value\ for\ summary/)
  end
end

