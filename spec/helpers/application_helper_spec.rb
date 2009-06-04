require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ApplicationHelper do
  describe "currency helpers" do
    before(:each) do
      @usd = create_currency("USD",:klass=>CurrencyIssued)
      @lets = create_currency("LETS",:klass=>CurrencyMutualCredit)
      @user1 = create_user('u1')
      @user2 = create_user('u2')
      @user3 = create_user('u3')
      @user4 = create_user('u4')
      @account1 = create_currency_account(@user1,@usd,'issuer')
      @account2 = create_currency_account(@user2,@usd,'user')
      @account3 = create_currency_account(@user3,@lets,'member')
      @account4 = create_currency_account(@user4,@lets,'aggregator')
    end

    describe "currencies_list_for_select" do
      it "should return a list of name/id pairs for building currency selects" do
        helper.currencies_list_for_select([@usd,c1]).should == [['USD',@usd.id],['LETS',@lets.id]]
      end
    end
    
    describe "currency_accounts" do
      it "should return a list of users in a currency" do
        helper.currency_accounts(@usd).should == [@account1,@account2]
      end
      it "should return a list of users in a currency less the excluded one" do
        helper.currency_accounts(@usd,:exclude=>@account1).should == [@account2]
      end
      it "should return a list of users of a given player class" do
        helper.currency_accounts(@usd,:player_class=>'issuer').should == [@account1]
      end
    end
    
    describe "currency_play_html" do
      it "should generate input html for a play" do
        helper.currency_play_html(@lets,'payment').should == 
          "<label for=\"from\">From:</label><select id=\"from\" include_blank=\"true\" name=\"from\"><option value=\"3\">Joe U3</option></select><br /><label for=\"to\">To:</label><select id=\"to\" include_blank=\"true\" name=\"to\"><option value=\"3\">Joe U3</option></select><br /><label for=\"aggregator\">Aggregator:</label><select id=\"aggregator\" include_blank=\"true\" name=\"aggregator\"><option value=\"4\">Joe U4</option></select><br /><label for=\"amount\">Amount:</label><input type=\"text\" id=\"amount name=\"amount\"><br /><label for=\"memo\">Memo:</label><textarea id=\"memo\" name=\"memo\"></textarea>"
      end
      it "should generate input html for a play with a field_prefix" do
        helper.currency_play_html(@lets,'payment',:field_id_prefix=>'play').should == 
          "<label for=\"play_from\">From:</label><select id=\"play_from\" include_blank=\"true\" name=\"play[from]\"><option value=\"3\">Joe U3</option></select><br /><label for=\"play_to\">To:</label><select id=\"play_to\" include_blank=\"true\" name=\"play[to]\"><option value=\"3\">Joe U3</option></select><br /><label for=\"play_aggregator\">Aggregator:</label><select id=\"play_aggregator\" include_blank=\"true\" name=\"play[aggregator]\"><option value=\"4\">Joe U4</option></select><br /><label for=\"play_amount\">Amount:</label><input id=\"play_amount\" name=\"play[amount]\" type=\"text\" /><br /><label for=\"play_memo\">Memo:</label><textarea id=\"play[memo]\" name=\"play[memo]\"></textarea>"
      end
      it "should generate input html for a play excluding the specified fiels" do
        helper.currency_play_html(@lets,'payment',:exclude =>['from','to','aggregator']).should == 
          "<label for=\"amount\">Amount:</label><input type=\"text\" id=\"amount name=\"amount\"><br /><label for=\"memo\">Memo:</label><textarea id=\"memo\" name=\"memo\"></textarea>"
      end
    end
  end
end