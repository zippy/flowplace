class UsersController < ApplicationController
  require_authentication :except => [:signup,:do_signup]
  require_authorization(:createAccounts, :only => [:new,:create]) 
  require_authorization(:accessAccounts, :only => [:edit,:update,:index]) 
  require_authorization(:admin, :only => [:login_as,:destroy,:logged_in_users]) 
  require_authorization(:assignPrivs, :only => [:permissions,:set_permissions]) 

	def logged_in_users
		current_time = Time.now
		@user_ids = get_logged_in_users  #hash of user ids, last_action values
  	@users = User.find(:all)
  	@logged_in_users = []
  	@users.each do |u|
	    if @user_ids[u.id]
	      @logged_in_users.push({:user => u, :last_action => @user_ids[u.id],:last_action_humanized => time_period_to_s(current_time - @user_ids[u.id])})
		  end
	 	end
	 	@logged_in_users.sort! {|u1,u2| u2[:last_action] <=> u1[:last_action] }
	end

	def time_period_to_s(time_period)
    result = []
    #interval_array = [ [:weeks, 604800], [:days, 86400], [:hours, 3600], [:mins, 60], [:secs, 1] ]
		interval_array = [[:minutes, 60], [:seconds, 1] ]
		interval_array.each do |sub|
			if time_period >= 0
				time_val, time_period = time_period.divmod( sub[1] )
				time_val == 1 ? name = sub[0].to_s.singularize : name = sub[0].to_s
				result << time_val.to_i.to_s + " #{name}"
			end
		end
		result.join(', ')
	end
	
  # GET /users
  # GET /users.xml
  def index
    @users = perform_search(OrderPairs,SearchPairs,SearchFormParams,User)
    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @users.to_xml }
    end
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/signup
  def signup
    return if !self_signup_ok?
    @user = User.new
  end
  
  # POST /users/signup
  def do_signup
    return if !self_signup_ok?
    @user = User.new(params[:user])
    raise "you can't sign up as circle user!" if @user.user_name =~ /_circle/
    respond_to do |format|
      if @user.create_bolt_identity(:user_name => :user_name,:enabled => false) && @user.save
        @user.activate! {|activation_code| activation_url(activation_code, :user_name=> @user.user_name)}
        flash[:notice] = "The account #{@user.user_name} has been created and activation instructions were sent to #{@user.email}.  Please check your e-mail and follow the instructions in the activation message."
        format.html { redirect_to  "/" }  #redirect_to  "/activations/show/"+@user.user_name
        format.xml  { head :created, :location => user_url(@user) }
      else
        format.html { render :action => "signup" }
        format.xml  { render :xml => @user.errors.to_xml }
      end
    end
  end

  # GET /users/1;edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])
    respond_to do |format|
      if @user.create_bolt_identity(:user_name => :user_name,:enabled => false) && @user.save
        do_extra_actions
        flash[:notice] = :user_created
        flash[:notice_param] = @user
        format.html { redirect_to users_url(:use_session => true) }
        format.xml  { head :created, :location => user_url(@user) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors.to_xml }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.update_attributes(params[:user])
        do_extra_actions
        format.html { redirect_to users_url(:use_session => true) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors.to_xml }
      end
    end
  end
  
  def convert_property_list(property)
    p = []
    params[property].each {|k,v| p << k if v} if params[property]
    params[:user][property] = p.join(",")
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    flash[:notice_param] = @user.user_name
    @user.destroy_with_identity
    respond_to do |format|
      flash[:notice] = :user_deleted
      format.html { redirect_to users_url(:use_session => true) }
      format.xml  { head :ok }
    end
  end

  # GET /users/1;login_as
  def login_as
    @user = User.find(params[:id])
    self.current_user = @user
    respond_to do |format|
      format.html { redirect_to home_url }
      format.xml  { head :ok }
    end
  end

  # GET /users/1;permissions
  def permissions
    @user = User.find(params[:id])
    @permissions = @user.roles.collect{|p| p.name}
    respond_to do |format|
      format.html # permissions.rhtml
      format.xml  { render :xml => @permissions.to_xml }
    end
  end

  # PUT /users/1;permissions
  def set_permissions
    @user = User.find(params[:id])
    
    @user.roles=[]
    if params[:perms]
      params[:perms].each {|r| role = Role.find_by_name(r);@user.roles << role}
    end
    respond_to do |format|
      format.html { redirect_to users_url(:use_session => true) }
      format.xml  { head :ok }
    end
  end
  
  # GET /users/1;preferences
  def preferences
    current_user_action do
      @preferences = @user.preferences.split(',') if @user.preferences?
      @preferences ||= []
      respond_to do |format|
        session[:prefs_return_to] = request.env['HTTP_REFERER'] if !session[:prefs_return_to]
        format.html # preferences.rhtml
        format.xml  { render :xml => @preferences.to_xml }
      end
    end
  end

  # PUT /users/1;preferences
  def set_preferences
    current_user_action do
      @user.update_attributes(:preferences => params[:prefs] ? params[:prefs].keys.join(',') : '')
      return_url = session[:prefs_return_to] || home_url
      respond_to do |format|
        flash[:notice] = :user_preferences_set
        flash[:notice_param] = @user
        format.html {redirect_to(return_url) }
        format.xml  { head :ok }
        session[:prefs_return_to] = nil
      end
    end
  end

  # GET /users/1;contact_info
  def contact_info
    current_user_action do
      session[:contact_info_return_to] = request.env['HTTP_REFERER'] if !session[:contact_info_return_to]
    end
  end

  # PUT /users/1;contact_info
  def set_contact_info
    current_user_action do
      return_url = session[:contact_info_return_to] || home_url
      respond_to do |format|
        if @user.update_attributes(params[:user])
          flash[:notice] = :user_contact_info_updated
          flash[:notice_param] = @user
          format.html { redirect_to(return_url) }
          format.xml  { head :ok }
          session[:contact_info_return_to] = nil
        else
          format.html { render :action => "contact_info" }
          format.xml  { render :xml => @user.errors.to_xml }
        end
      end
    end
  end
  
  def email
    u = User.find(params[:id])
    if u
      @to_email = u.email
      @to_name = u.full_name
    end
    @subject = params[:subject] if params[:subject]
    @from_email = current_user.email
    render :action => "email", :layout => false
  end
  
  def process_email
    if params[:body].blank?
      @body_error = true
    end
    if params[:to_email].blank?
      @to_error = true
    elsif params[:to_email] !~ EmailAddressRegEx
      @to_error_bad_format = true
    end
    u = User.find(params[:id])
    if u
      @to_name = u.full_name
    end
    @to_email = params[:to_email]
    @from_email = current_user.email
    @from_name = current_user.full_name
    @subject = params[:subject]
    @body = params[:body]
    unless @to_error || @to_error_bad_format || @body_error  
      @processed = true 
      p = params
      p.update(:to_email => [@to_email,@from_email].join(', '),:subject => @subject,:from_email => @from_email,:from_name => @from_name,:body => @body)
      begin
        @the_email = UserMailer.deliver_user(p)
        Event.create(:user_id=>current_user.id,:event_type=>'email',:sub_type =>"e-mail out",:content => "from: #{p[:from_email]}<br/> to: #{@to_email}<br/> subject: #{p[:subject]}",:content_extra => @body )
      rescue Exception => e
        @delivery_failed = e.to_s
      end
    end     
    render :action => "email", :layout => false
  end
  
  protected
  def current_user_action
    if current_user_or_can?([:accessAccounts,:createAccounts])
      @user = User.find(params[:id])
      yield
    end
  end

  def do_extra_actions
    if current_user.can?(:admin)
      if params[:autojoin]
        begin
          autojoin = Configuration.get(:autojoin)
          if autojoin.blank?
            flash[:action_error] = 'autojoin configuration is empty (<a href="/configurations">configure</a>)'
          else
            autojoin = YAML.load(autojoin)
            circles = autojoin['circles'].split(/\W*,\W*/) if autojoin['circles'].is_a?(String)
            circles = autojoin['circles'] if autojoin['circles'].is_a?(Array)
            circles.each do |name|
              c = Currency.find_by_name(name)
              raise "circle #{name} not found!" if c.nil? || !c.is_a?(CurrencyMembrane)
              c.add_player_to_circle('member',@user)
            end
            flash[:notice] = "autojoined #{@user.full_name} (#{autojoin.inspect})"
          end
        rescue Exception => e
          flash[:action_error] = "autojoin configuration was invalid (configuration: #{autojoin.inspect}; error: #{e.to_s})"
        end
      end
    end
    
    if current_user.can?(:createAccounts)
      flash[:notice_param] = @user
      if params[:activate_account] && @user.deactivated?
        @user.activate! {|activation_code| activation_url(activation_code, :user_name=> @user.user_name)}
        flash[:notice] = :user_activated
      end
      if params[:deactivate_account] && @user.activated?
        @user.deactivate!
        flash[:notice] = :user_deactivated
      end
      if params[:resend_activation] && @user.activation_pending?
        BoltNotifications.deliver_activation_notice(@user, @user.bolt_identity, activation_url(@user.bolt_identity.activation_code, :user_name=> @user.user_name))
        flash[:notice] = :user_activation_resent
      end
      if params[:assign_paper_code] && !@user.paper_code?
        @user.assign_paper_code
      end
      if params[:reset_password]
        i = @user.bolt_identity
        if i.enabled
          raise i.inspect if !i.valid?
          i.reset_code! if i.reset_code.blank? # keep old reset code
          accounts = [{:identity => i, :url =>resetcode_password_url(i.reset_code, :host => request.host_with_port, :user_name => i.user_name)}]
          @email_text = BoltNotifications.deliver_password_reset_notice(@user.email,accounts)
          flash[:notice] = :password_reset
        end
      end
    end
  end
  
  def self_signup_ok?
    if Configuration.get(:new_user_policy) != 'self_signup'
      redirect_to home_url
      false
    else
      true
    end
  end
    

end
