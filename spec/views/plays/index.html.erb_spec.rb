require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/plays/index.html.erb" do
  include PlaysHelper
  
  before(:each) do
    assigns[:plays] = [
      stub_model(Play,
        :currency_account_id => 1,
        :content => "value for content"
      ),
      stub_model(Play,
        :currency_account_id => 1,
        :content => "value for content"
      )
    ]
  end

  it "renders a list of plays" do
    render
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", "value for content".to_s, 2)
  end
end

