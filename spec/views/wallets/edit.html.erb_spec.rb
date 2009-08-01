require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/wallets/edit.html.erb" do
  include WalletsHelper
  
  before(:each) do
    assigns[:wallet] = @wallet = stub_model(Wallet,
      :new_record? => false,
      :name => "value for name",
      :user_id => 1
    )
  end

  it "renders the edit wallet form" do
    render
    
    response.should have_tag("form[action=#{wallet_path(@wallet)}][method=post]") do
      with_tag('input#wallet_name[name=?]', "wallet[name]")
      with_tag('input#wallet_user_id[name=?]', "wallet[user_id]")
    end
  end
end


