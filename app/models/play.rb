class Play < ActiveRecord::Base
  belongs_to :currency_account
  validates_presence_of :currency_account_id,:content
end
