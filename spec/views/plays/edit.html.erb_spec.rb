require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/plays/edit.html.erb" do
  include PlaysHelper
  
  before(:each) do
    assigns[:play] = @play = stub_model(Play,
      :new_record? => false,
      :currency_account_id => 1,
      :content => "value for content"
    )
  end

  it "renders the edit play form" do
    render
    
    response.should have_tag("form[action=#{play_path(@play)}][method=post]") do
      with_tag('input#play_currency_account_id[name=?]', "play[currency_account_id]")
      with_tag('textarea#play_content[name=?]', "play[content]")
    end
  end
end


