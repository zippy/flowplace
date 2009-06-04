require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/plays/new.html.erb" do
  include PlaysHelper
  
  before(:each) do
    assigns[:play] = stub_model(Play,
      :new_record? => true,
      :currency_account_id => 1,
      :content => "value for content"
    )
  end

  it "renders new play form" do
    render
    
    response.should have_tag("form[action=?][method=post]", plays_path) do
      with_tag("input#play_currency_account_id[name=?]", "play[currency_account_id]")
      with_tag("textarea#play_content[name=?]", "play[content]")
    end
  end
end


