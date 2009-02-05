class Currency < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name

  belongs_to :circle
  has_many :currency_weal_links, :dependent => :destroy
  has_many :weals, :through => :currency_weal_links

end
