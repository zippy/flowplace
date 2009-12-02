class Proposal < ActiveRecord::Base
  validates_presence_of :user_id,:weal_id,:as,:description
  belongs_to :user
  belongs_to :weal
end
