class UsersController < ApplicationController
  skip_before_filter :authenticate_user!, :only => [:signup,:do_signup,:accept_invitation,:do_accept_invitation]

  def logged_in_users
    authorize! :read, :logged_in_users
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

  # GET /users
  # GET /users.xml
  def index
    authorize! :read, User
    if params['search'] && params['search']['for_main'].blank?
      @display_all = true
    end
    @users = perform_search(OrderPairs,SearchPairs,SearchFormParams,User)
    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @users.to_xml }
    end
  end

  # GET /users/new
  def new
    authorize! :create, User
    @user = User.new
  end

  # GET /users/1;edit
  def edit
    authorize! :edit, User
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.xml
  def create
    authorize! :create, User
    @user = User.new(params[:user])
    @user.enabled = false
    respond_to do |format|
      if @user.valid? && @user.save
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
    authorize! :edit, User
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

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    authorize! :delete, User
    @user = User.find(params[:id])
    flash[:notice_param] = @user.user_name
    @user.destroy
    respond_to do |format|
      flash[:notice] = :user_deleted
      format.html { redirect_to users_url(:use_session => true) }
      format.xml  { head :ok }
    end
  end

  # GET /users/1;login_as
  def login_as
    authorize! :login_as, User
    @user = User.find(params[:id])
    sign_in(:user, @user)
    redirect_to home_url
  end

  # GET /users/1;permissions
  def permissions
    authorized_if :assignPrivs
    @user = User.find(params[:id])
    @permissions = @user.get_privs
    respond_to do |format|
      format.html # permissions.rhtml
      format.xml  { render :xml => @permissions.to_xml }
    end
  end

  # PUT /users/1;permissions
  def set_permissions
    authorized_if :assignPrivs
    @user = User.find(params[:id])
    
    if params[:perms]
      privs = []
      params[:perms].keys.each {|r| privs << r}
      @user.set_privs(privs)
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
      @user.update_attributes(:preferences => params[:prefs] ? params[:prefs].keys.join(',') : '',:language => params['language'])
      if Configuration.get(:circle_currency_policy) == 'self_authorize'
        @user.delete_privs(:currency,:circle)
        @user.add_privs(:currency,:circle) if params[:circle_currency_management]
      end
      if Configuration.get(:annotations_policy) =~ /^self_authorize/
        @user.delete_privs(:view_annotations)
        @user.add_privs(:view_annotations) if params[:view_annotations]
      end
      if Configuration.get(:annotations_policy) == 'self_authorize_view_edit'
        @user.delete_privs(:edit_annotations)
        @user.add_privs(:edit_annotations) if params[:edit_annotations]
      end
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

  # GET /users/1;password_change
  def password_change
    authorize! :change_password, User
    current_user_or_can?(:admin)
    @user = User.find(params[:id])
  end

  # PUT /users/1;do_password_change
  def do_password_change
    authorize! :change_password, User
    if current_user_or_can?(:admin)
      @user = User.find(params[:id])
      if @user == current_user
        @user.errors.add(:current_password," is incorrect.") if !@user.valid_password?(params[:current_password])
      end
      @user.attempt_set_password(params) if @user.errors.empty?
      if @user.errors.empty?
        sign_in(:user, @user)
        flash[:notice] = :password_changed
        flash[:notice_param] = @user
        redirect_to home_url
      else
        render :action => "password_change"
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
  
  # GET /users/accept_invitation/1/joe@email.com
  def accept_invitation
    @email = params[:email]
    if verify_invitation
      @user = User.find_by_email(@email)
      if !@user.nil?
        _do_accept_invitation
      end
      # render the accept_invitation signup form
    else
      access_denied
    end
  end

  # POST /users/accept_invitation
  def do_accept_invitation
    @email = params[:user][:email]
    if verify_invitation
      @user = User.new(params[:user])
      raise "you can't sign up as circle user!" if @user.user_name =~ /_circle/

      @user.password = params[:password]
      @user.password_confirmation = params[:confirmation]
      @user.skip_confirmation!
      if @user.valid? && @user.save
        _do_accept_invitation  #redirect_to  "/activations/show/"+@user.user_name
      else
        render :action => "accept_invitation"
      end
    else
      access_denied
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
  
  def verify_invitation
    @currency_account = CurrencyAccount.find(params[:currency_account_id])
    
    # Confirm that there is an invitiation as specified in the URL
    if !@currency_account.nil? && (@circle = @currency_account.currency).is_a?(CurrencyMembrane)
      @state = @currency_account.get_state
      if @state
        @invitations = @state['invitations']
        if @invitations && @invitations[@email]
          return true
        end
      end
    end
    false
  end
  
  def _do_accept_invitation
    namer_account = @circle.api_user_accounts('namer',current_user)[0]
    @circle.add_player_to_circle('member',@user,namer_account)
    sign_in(:user, @user)
    flash[:notice] = "You have been added to: #{@circle.name}"
    redirect_to(dashboard_url)
    @invitations.delete(@email)
    @state['invitations_accepted'] ||= {}
    @state['invitations_accepted'][@email] = @user.user_name
    @currency_account.save
  end
  
  def current_user_action
    if current_user_or_can?([:accessAccounts,:createAccounts])
      @user = User.find(params[:id])
      yield
    end
  end

  def do_extra_actions
    if current_user_can?(:admin)
      if params[:autojoin]
        err = @user.autojoin
        if err.nil?
          flash[:notice] = "autojoined #{@user.full_name}"
        else
          flash[:action_error] = err
        end
      end
    end
    
    if current_user_can?(:createAccounts)
      flash[:notice_param] = @user
      if params[:activate_account] && @user.deactivated?
        @user.activate!
        flash[:notice] = :user_activated
      end
      if params[:deactivate_account] && @user.activated?
        @user.deactivate!
        flash[:notice] = :user_deactivated
      end
      if params[:resend_activation] && @user.activation_pending?
        @user.resend_activation_message
        flash[:notice] = :user_activation_resent
      end
      if params[:reset_password]
        @user.send_reset_password_instructions
        flash[:notice] = :password_reset
      end
    end
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


end
