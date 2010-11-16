require 'lib/constants'
class User < ActiveRecord::Base
  is_gravtastic

  has_many :stewarded_currencies, :class_name => 'Currency', :foreign_key => :steward_id
  has_many :currency_accounts, :dependent => :destroy
  has_many :weals_as_offerer, :class_name => 'Weal', :foreign_key => :offerer_id
  has_many :weals_as_requester, :class_name => 'Weal', :foreign_key => :requester_id
  has_many :proposals
  has_many :activities
  has_many :wallets
  belongs_to :circle, :class_name => 'Currency' #this is for users that are a circle

  Permissions = %w(dev admin assignPrivs createAccounts accessAccounts circle currency view_annotations edit_annotations admin_annotations)
  Preferences = %w(terse enlargeFont)
  Languages = [["English", 'en'], ["French", 'fr'],["Spanish",'es']]
  
  validates_uniqueness_of :user_name
  validates_presence_of :user_name,:first_name,:last_name
  validates_format_of :email, :with => EmailAddressRegEx

  attr_protected :account_id,:last_login,:last_login_ip,:created_at
  cattr_reader :per_page
  @@per_page = 10
  
  ##############################################
  # rename the user
  def rename(new_name)
    self.user_name = new_name
    User.transaction do
      if self.save
        self.bolt_identity.user_name = new_name
        self.bolt_identity.save!
      end
    end
    self
  end
  
  ##############################################
  def weals(circle=nil)
    _find_weals(['offerer_id = ? or requester_id = ? or proposals.user_id = ?',self.id,self.id,self.id],circle)
  end

  ##############################################
  def intentions(circle=nil)
    _find_weals(["(offerer_id = ? or requester_id = ? ) and phase ='intention'",self.id,self.id],circle)
  end

  ##############################################
  def proposed_intentions(circle=nil)
    _find_weals(["proposals.user_id = ? and phase ='intention'",self.id],circle)
  end
  
  def _find_weals(conditions,circle=nil)
    if circle
      conditions[0] += ' and circle_id = ?'
      conditions.push circle.id
    end  
    Weal.find(:all,:conditions => conditions,:include =>:proposals,:order => 'lft')
  end

  ##############################################
  def actions(circle=nil)
    _find_weals(["(offerer_id = ? or requester_id = ?) and phase ='action'",self.id,self.id],circle)
  end

  ##############################################
  def assets(circle=nil)
    _find_weals(["(offerer_id = ? or requester_id = ?) and phase ='asset'",self.id,self.id],circle)
  end
  
  ##############################################
  def full_name(lastname_first = false)
    if lastname_first
      "#{last_name}, #{first_name}"
    else
      "#{first_name} #{last_name}"
    end
  end


  ##############################################
  def before_create
    self.language = Configuration.get(:default_language) if self.language.blank?
    true
  end

  ##############################################

  # Bolt calls this method at login time if it exists
  def login_action(request)
    self.last_login = Time.now
    self.last_login_ip = request.remote_ip
    self.time_local = (!request.cookies["timeLocal"].empty? ? request.cookies["timeLocal"][0] : '')
   	self.timezone_offset = (!request.cookies["timezoneOffset"].empty? ? request.cookies["timezoneOffset"][0].to_i : 14400)
    self.save
#    Event.create(:user_id=>self.id,:event_type=>'login',:sub_type =>"success",:content => request.remote_ip)
    
    # clean up stale sessions
    last_week = (1.week.ago).to_formatted_s(:db)
    CGI::Session::ActiveRecordStore.session_class.delete_all("updated_at < '#{last_week}'")
  end
  
  def deactivated?
    !bolt_identity.enabled? && bolt_identity.activation_code.blank?
  end

  def activated?
    bolt_identity.enabled? && bolt_identity.activation_code.blank?
  end
  
  def activation_pending?
    !bolt_identity.enabled? && !bolt_identity.activation_code.blank?
  end

  def activate!
    identity = self.bolt_identity
    identity.require_activation! {|code| yield code}
    identity.save
  end

  def deactivate!
    identity = self.bolt_identity
    identity.enabled = false
    identity.activation_code = nil
    identity.save
  end
  
  def acknowledge_tip
    self.tip_type = 'none'
    save
  end
  
  ##############################################
  # returns true if this user represents a circle
  def is_circle?
    return !circle.nil?
  end
  
  ##############################################
  def has_preference(pref)
    preferences && preferences.include?(pref)
  end
  
  ##############################################
  def destroy_with_identity
    bolt_identity.destroy if bolt_identity
    destroy
  end
  
  ##############################################
  def privs
    roles.collect {|r| r.name.intern}
  end

  ##############################################
  def localize_time(the_time)
    #TODO FIX THIS!
    return the_time
    if the_time && self.timezone_offset
      the_time - self.timezone_offset - SystemTZOffset
    else
      the_time
    end
  end

  ##############################################
  # currencies returns a list of all the currencies the user has joined
  def currencies
    currency_accounts.collect {|ca| ca.currency}
  end

  ##############################################
  # currencies returns a list of all the currencies the user has joined in a particular circle
  def currency_accounts_in_circle(circle)
    currencies_in_circle = circle.currencies
    self.currency_accounts.find_all {|ca| currencies_in_circle.include?(ca.currency) || ca.currency==circle}
  end

  ##############################################
  # checks whether user is a member of the given currency
  def has_joined?(currency)
    currencies.include?(currency)
  end

  ##############################################
  # returns a list of player classes that a user is, in the given currency
  def player_clasess_in(currency)
    if currencies.include?(currency)
      currency_accounts.collect {|ca| ca.currency == currency ? ca.player_class : nil}.compact
    else
      []
    end
  end
  
  ##############################################
  # joinable_currencies returns a list of all the currencies the user can join
  def joinable_currencies
    c = Currency.find(:all)
    c -= currencies if !has_preference('multi_wallet') || wallets.size == 0
    c
  end
  
  ##############################################
  # list of circles in which user is a member
  def circle_memberships
    result = []
    currency_accounts.each {|ca| result.push(ca.currency) if ca.currency.is_a?(CurrencyMembrane)}
    result.uniq
  end
  
  ##############################################
  # auto-join this user according to the configuration
  def autojoin
    err = nil
    begin
      autojoin = Configuration.get(:autojoin)
      if autojoin.blank?
        err = 'autojoin configuration is empty (<a href="/configurations">configure</a>)'
      else
        autojoin = YAML.load(autojoin)
        circles = autojoin['circles'].split(/\W*,\W*/) if autojoin['circles'].is_a?(String)
        circles = autojoin['circles'] if autojoin['circles'].is_a?(Array)
        circles.each do |name|
          c = Currency.find_by_name(name)
          raise "circle #{name} not found!" if c.nil? || !c.is_a?(CurrencyMembrane)
          namers = c.api_user_accounts('namer')
          c.add_player_to_circle('member',self,namers[0])
        end
      end
    rescue Exception => e
      err = "autojoin failed (configuration: #{autojoin.inspect}; error: #{e.to_s})"
    end
    err
  end
end
