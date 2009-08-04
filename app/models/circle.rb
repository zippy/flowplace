class Circle < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name

  has_many :circle_user_links, :dependent => :destroy
  has_many :users, :through => :circle_user_links
  has_one :user_account, :foreign_key => 'circle_id',:class_name => 'User'
  
end
