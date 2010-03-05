class PlayCurrencyAccountLink < ActiveRecord::Base
  belongs_to :currency_account
  belongs_to :play
  validates_uniqueness_of :currency_account_id, :scope => :play_id
  validates_uniqueness_of :play_id, :scope => :currency_account_id
end
