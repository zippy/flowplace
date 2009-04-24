class Weal < ActiveRecord::Base

  validates_presence_of :title
  validates_uniqueness_of :title

  acts_as_nested_set
  acts_as_taggable_on :tags
  
  belongs_to :offerer, :class_name => 'User', :foreign_key => 'offerer_id'
  belongs_to :requester, :class_name => 'User', :foreign_key => 'requester_id'

  has_many :currency_weal_links, :dependent => :destroy
  has_many :currencies, :through => :currency_weal_links
  has_many :proposals, :dependent => :destroy
  
  has_many :intention_activities, :as => :activityable

  Phases = %w(intention project)
  def initialize(attrs=nil)
    super(attrs)
    self.phase = 'intention'
  end

  def created_by
    self.created_by_requester ? requester : offerer
  end

  def matched?
    requester && offerer ? true : false
  end
  
  protected

  def validate
    if requester_id.blank? && offerer_id.blank?
      errors.add_to_base("Must have a requester or offerer")
    else
      errors.add_to_base("Must have a requester if created by requester is true") if requester_id.blank? && created_by_requester?
      errors.add_to_base("Must have an offerer if created by requester is false") if offerer_id.blank? && !created_by_requester?
    end
  end
end
