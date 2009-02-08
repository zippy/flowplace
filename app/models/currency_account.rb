class CurrencyAccount < ActiveRecord::Base
  belongs_to :currency
  belongs_to :user
  validates_presence_of :currency_id,:user_id
  validates_uniqueness_of :currency_id, :scope => :user_id
  validates_uniqueness_of :user_id, :scope => :currency_id
end
