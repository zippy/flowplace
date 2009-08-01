require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/wallets/index.html.erb" do
  include WalletsHelper
  
  before(:each) do
    assigns[:wallets] = [
      stub_model(Wallet,
        :name => "value for name",
        :user_id => 1
      ),
      stub_model(Wallet,
        :name => "value for name",
        :user_id => 1
      )
    ]
  end

  it "renders a list of wallets" do
    render
    response.should have_tag("tr>td", "value for name".to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
  end
end

