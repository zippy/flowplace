class CurrencyWealLink < ActiveRecord::Base
  belongs_to :currency
  belongs_to :weal
  validates_uniqueness_of :currency_id, :scope => :weal_id
  validates_uniqueness_of :weal_id, :scope => :currency_id
end
