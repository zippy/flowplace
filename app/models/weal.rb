class Weal < ActiveRecord::Base

  validates_presence_of :title
  validates_uniqueness_of :title

  acts_as_nested_set
  acts_as_taggable_on :tags
  
  belongs_to :fulfiller, :class_name => 'User', :foreign_key => 'fulfiller_id'
  belongs_to :requester, :class_name => 'User', :foreign_key => 'requester_id'

  has_many :currency_weal_links, :dependent => :destroy
  has_many :currencies, :through => :currency_weal_links
  has_many :proposals, :dependent => :destroy

  Phases = %w(intention project)
  def initialize(attrs=nil)
    super(attrs)
    self.phase = 'intention'
  end

  def created_by
    self.created_by_requester ? requester : fulfiller
  end

  def matched?
    requester && fulfiller ? true : false
  end
  
  protected

  def validate
    errors.add_to_base("Must have a requester or fulfiller") if requester_id.blank? && fulfiller_id.blank?
  end
end
