require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/wallets/show.html.erb" do
  include WalletsHelper
  before(:each) do
    assigns[:wallet] = @wallet = stub_model(Wallet,
      :name => "value for name",
      :user_id => 1
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/value\ for\ name/)
    response.should have_text(/1/)
  end
end

