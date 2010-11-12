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
        helper.currencies_list_for_select([@usd,@lets]).should == [["USD: ", 1], ["LETS: ", 2]]
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
        helper.currency_play_html(@lets,@account2,'pay').should == 
          "Joe U2 pays <select id=\"to\" include_blank=\"true\" name=\"to\"><option value=\"3\">Joe U3</option></select> <input id=\"amount\" name=\"amount\" size=\"4\" type=\"text\" value=\"\" /> for <input id=\"memo\" name=\"memo\" size=\"30\" type=\"text\" value=\"\" /><input type=\"hidden\" name=\"play_name\" value=\"pay\">"
      end
      it "should generate input html for a play with a field_prefix" do
        helper.currency_play_html(@lets,@account2,'pay',:field_id_prefix=>'play').should == 
          "Joe U2 pays <select id=\"play_to\" include_blank=\"true\" name=\"play[to]\"><option value=\"3\">Joe U3</option></select> <input id=\"play_amount\" name=\"play[amount]\" size=\"4\" type=\"text\" value=\"\" /> for <input id=\"play_memo\" name=\"play[memo]\" size=\"30\" type=\"text\" value=\"\" /><input type=\"hidden\" name=\"play_name\" value=\"pay\">"
      end
      it "should generate input html for a play excluding the specified fields" do
        helper.currency_play_html(@lets,@account2,'pay',:exclude =>['from']).should == 
          " pays <select id=\"to\" include_blank=\"true\" name=\"to\"><option value=\"3\">Joe U3</option></select> <input id=\"amount\" name=\"amount\" size=\"4\" type=\"text\" value=\"\" /> for <input id=\"memo\" name=\"memo\" size=\"30\" type=\"text\" value=\"\" /><input type=\"hidden\" name=\"play_name\" value=\"pay\">"
      end
      it "should generate input html for boolean types" do
        @circle = create_currency("C",:klass=>CurrencyMembrane)
        @memb = create_currency_account(@user1,@circle,'member')
        helper.currency_play_html(@circle,@memb,'bind_currency').should == 
          " Joe U1 binds <select id=\"currency\" name=\"currency\"><option value=\"\" selected=\"selected\"></option>\n<option value=\"USD\">USD</option>\n<option value=\"LETS\">LETS</option>\n<option value=\"C\">C</option></select> to <select id=\"to\" include_blank=\"true\" name=\"to\"></select> as <input id=\"name\" name=\"name\" size=\"30\" type=\"text\" value=\"\" /> with autojoin as <select id=\"autojoin\" name=\"autojoin\"><option value=\"0\">false</option>\n<option value=\"1\">true</option></select><input type=\"hidden\" name=\"play_name\" value=\"bind_currency\">"
      end
    end
  end
end