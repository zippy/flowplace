require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/currency_accounts/edit.html.erb" do
  include CurrencyAccountsHelper
  
  before(:each) do
    assigns[:currency_account] = @currency_account = stub_model(CurrencyAccount,
      :new_record? => false,
      :user_id => 1,
      :currency_id => 1,
      :player_class => "member"
      :state => "value for state"
    )
  end

  it "should render edit form" do
    render "/currency_accounts/edit.html.erb"
    
    response.should have_tag("form[action=#{currency_account_path(@currency_account)}][method=post]") do
      with_tag('input#currency_account_user_id[name=?]', "currency_account[user_id]")
      with_tag('input#currency_account_currency_id[name=?]', "currency_account[currency_id]")
      with_tag('input#player_class[name=?]', "currency_account[player_class]")
      with_tag('textarea#currency_account_state[name=?]', "currency_account[state]")
    end
  end
end


