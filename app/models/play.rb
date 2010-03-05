class Play < ActiveRecord::Base
  has_many :play_currency_account_links, :dependent => :destroy
  has_many :currency_accounts, :through => :play_currency_account_links
  validates_presence_of :content
end
