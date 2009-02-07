class Activity < ActiveRecord::Base
  belongs_to :user
  belongs_to :activityable, :polymorphic => true
  validates_presence_of :user_id,:type,:activityable_id

  def self.add(user,object,contents)
    a = self.new(:user => user,:contents=>contents)
    a.activityable = object
    a.save!
    a
  end

  def activityable_type=(sType)
     super(sType.to_s.classify.constantize.base_class.to_s)
  end

  def humanize
    self.class.to_s =~ /(.*)Activity/
    $1
  end
end

class IntentionActivity < Activity
end

class CircleActivity < Activity
end
