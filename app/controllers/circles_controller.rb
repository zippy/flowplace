class CirclesController < ApplicationController

  before_filter :set_current_circle ,:except => :index
  # GET /circles
  # GET /circles.xml
  def index
    authorize! :read, :circle
    @membranes = Currency.find(:all,:conditions => "type = 'CurrencyMembrane'",:include => :currency_accounts)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @circles }
    end
  end

  # GET /circles/1
  # GET /circles/1.xml
  def show
    authorize! :read, :circle
    @circle = Currency.find(params[:id])
    namer?
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @circle }
    end
  end

  # GET /circles/new
  # GET /circles/new.xml
  def new
    authorize! :create, :circle
    @circle = Currency.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @circle }
    end
  end

  # GET /circles/1/edit
  def edit
    authorize! :edit, :circle
    @circle = Currency.find(params[:id])
    return if am_not_namer?
  end

  # POST /circles
  # POST /circles.xml
  def create
    authorize! :create, :circle
    Activity
    Currency
    @circle = CurrencyMembrane.create(current_user,params)

    respond_to do |format|
      if @circle.errors.empty?
        CircleActivity.add(current_user,@circle,'created')
        flash[:notice] = 'Circle was successfully created.'
        format.html { redirect_to circles_path } #edit_circle_path(@circle) }
        format.xml  { render :xml => @circle, :status => :created, :location => @circle }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @circle.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /circles/1
  # PUT /circles/1.xml
  def update
    authorize! :edit, :circle
    @circle = Currency.find(params[:id])
    return if am_not_namer?
    if params[:circle][:name] != @circle.name
      circle_user = User.find_by_user_name(circle_user_orig_name = @circle.circle_user_name)
      Currency.transaction do
        @circle.update_attributes(params[:circle])
        if @circle.errors.empty?
          circle_user.rename(circle_user_new_name = @circle.circle_user_name)
          if !circle_user.errors.empty?
            @circle.errors.add_to_base('Error renaming circle user:'+@circle.errors.full_messages)
          else
            CurrencyAccount.update_all "name = '#{circle_user_new_name}'", ['user_id = ? and name = ?',circle_user.id,circle_user_orig_name]
          end
        end
      end
    else
      @circle.update_attributes(params[:circle])    
    end
    
    respond_to do |format|
      if @circle.errors.empty?
        flash[:notice] = 'Circle was successfully updated.'
        format.html { redirect_to circles_path }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @circle.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /circles/1
  # DELETE /circles/1.xml
  def destroy
    authorize! :delete, :circle
    @circle = Currency.find(params[:id])
    return if am_not_namer?
    circle_user = User.find_by_user_name(@circle.circle_user_name)
    Currency.transaction do
      if !circle_user.nil?
        circle_user.destroy
      end
      @circle.destroy
    end
    respond_to do |format|
      format.html { redirect_to(circles_url) }
      format.xml  { head :ok }
    end
  end

  # GET /circles/1/players
  def players
    authorize! :edit, :circle
    @circle = Currency.find(params[:id])
    return if am_not_namer?
    setup_players_users
  end
  
  # PUT /circles/1/players
  def set_players
    authorize! :edit, :circle
    @circle = Currency.find(params[:id])
    return if am_not_namer?
    
    case params["commit"]
    when "Add >>"
      selector = :users

      player_class = params[:player_class]
      if player_class.blank?
        @circle.errors.add_to_base('You must choose a role!')
      end
      if !params[:users]
        @circle.errors.add_to_base('You must choose some users!')
      end
    when "<< Remove"
      selector = :players
      if !params[selector]
        @circle.errors.add_to_base('You must choose some players!')
      end
    else
      raise "invalid commit"
    end
    
    if @circle.errors.empty?
      params[selector].keys.each do |selector_id|
        # this is all really messed up because the containment relationship aren't correct
        # Really it is the namer in the super circle that should be naming players as members and namers
        # in sub-circles... but we don't do it that way yet...
        namer_account = @circle.api_user_accounts('namer',current_user)[0]
        case selector
        when :users
          user = User.find(selector_id)
          @circle.add_player_to_circle(player_class,user,namer_account)
        when :players
          to_account = CurrencyAccount.find(selector_id)
          if to_account.player_class != 'member'
            to_account.destroy
          else
            play = {
              'from' => namer_account,
              'to' => to_account,
              'currency' => @circle,
              'player_class' => 'member'
            }
            begin
              @circle.api_play('revoke',namer_account,play)
            rescue Exception => e
              raise e
            end
          end
        end
      end
      flash[:notice] = 'Circle was successfully updated.'
      redirect_to(players_circle_url(@circle))
    else
      setup_players_users
      render :action => 'players'
    end
  end

  # GET /circles/1/link_players
  def link_players
    authorize! :edit, :circle
    @circle = Currency.find(params[:id])
    @bound_currencies = @circle.currencies
    get_bound_currencies(@circle)
    return if am_not_namer?
    setup_link_players('member')    
  end
  
  # PUT /circles/1/set_link_players
  def set_link_players
    authorize! :edit, :circle
    @circle = Currency.find(params[:id])
    @bound_currencies = @circle.currencies
    currencies = params[:currencies]
    return if am_not_namer?
    if !params[:users]
      @circle.errors.add_to_base('You must choose some players!')
    end
    if currencies.nil?  || currencies.empty?
      @circle.errors.add_to_base('You must choose some currency roles!')
    end
    if @circle.errors.empty?
      #TODO, this needs updating if the same user can have multiple accounts in the same currency as namer
      namer_account = @circle.api_user_accounts('namer',current_user)[0]
      params[:users].keys.each do |user_id|
        user = User.find(user_id)
        self_account = User.find_by_user_name(@circle.circle_user_name).currency_accounts[0]
        
        currencies.keys.each do |currency_id|
          currency = Currency.find(currency_id)
          currencies[currency_id].keys.each do |pc|
            to_account = @circle.api_user_accounts('member',user).first
            play = {
              'from' => namer_account,
              'to' => to_account,
              'currency' => currency,
              'player_class' => pc
            }
            begin
              play_name = params["commit"] == "Unlink" ? 'revoke' : 'grant'
              @circle.api_play(play_name,namer_account,play)
            rescue Exception => e
              raise e unless e.to_s =~ /You are allready a member of that currency/
            end
          end
        end
      end
      flash[:notice] = 'Players were successfully linked.'
      redirect_to(link_players_circle_url(@circle))
    else
      setup_link_players('member')
      render :action => 'link_players'
    end
    
  end

  # GET /circles/1/currencies
  def currencies
    authorize! :edit, :circle
    @circle = Currency.find(params[:id])
    return if am_not_namer?
    setup_bound_currencies
  end
  
  # PUT /circles/1/currencies
  def set_currencies
    authorize! :edit, :circle
    @circle = Currency.find(params[:id])
    return if am_not_namer?
    case params["commit"]
    when "Add >>"
      selector = :currencies
      play_name = 'bind_currency'
    when "<< Remove"
      selector = :bound_currencies
      play_name = 'unbind_currency'
    end
    
    if !params[selector] 
      @circle.errors.add_to_base('You must choose some currencies!')
    end
    if @circle.errors.empty?
      params[selector].keys.each do |currency_id|
        currency = Currency.find(currency_id)
        self_account = User.find_by_user_name(@circle.circle_user_name).currency_accounts[0]
        #TODO, this needs updating if the same user can have multiple accounts in the same currency as namer
        namer_account = @circle.api_user_accounts('namer',current_user)[0]
        
        play = {
          'from' => namer_account,
          'to' => self_account,
          'currency' => currency
        }
        play['autojoin'] = params['autojoin'] if selector == :currencies
        @circle.api_play(play_name,namer_account,play)
      end
      flash[:notice] = 'Circle was successfully updated.'
      redirect_to(currencies_circle_url(@circle))
    else
      setup_bound_currencies
      render :action => 'currencies'
    end
  end

  #GET /circles/members
  def members
    authorize! :read, :circle
    @users = @current_circle.api_user_accounts('member').collect{|ca| ca.user}.uniq
  end
  
  private
  def setup_bound_currencies
    set_params(:circle_currencies,true)
    key = @search_params['key']
    
    if key.blank?
      conditions = "type != 'CurrencyMembrane'"
    else
      key = '%'+key+'%'
      conditions = ["type != 'CurrencyMembrane' and (name #{ILIKE} ?)",key]
    end
    if current_user_can?(:admin)
      @currencies = Currency.find(:all,:conditions=>conditions)
    else
      @currencies = current_user.stewarded_currencies.find(:all,:conditions=>conditions)
    end
    get_bound_currencies(@circle)
    @currencies = @currencies - @bound_currencies
    @currencies = @currencies.paginate(:page => params[:page],:per_page => params[:per_page])
    @paginate_bound_currencies = false # !@bound_currencies.empty?
  end
  
  def get_bound_currencies(circle)
    @bound_currency_hash = circle.currencies(true)
    @bound_currencies = @bound_currency_hash.keys.collect {|n| @bound_currency_hash[n]['currency']}
    @bound_currencies =  @bound_currencies.sort {|x,y| x.name <=> y.name}
  end
  
  def setup_users
    key = @search_params['key']
    if key.blank?
      @users = User.find(:all)
    else
      key = '%'+key+'%'
      @users = User.find(:all,:conditions=>["#{SQL_FULL_NAME} #{ILIKE} ? or user_name #{ILIKE} ?",key,key])
    end
    @users ||=[]
    @total_users = @users.size
    @paginate_users = @search_params['paginate'] == 'yes'
    @users = @users.paginate(:page => params[:page],:per_page => params[:per_page]) if @paginate_users
  end
  
  def setup_players(circle_player_class)
    @players = []
    
    circle_user_name = @circle.circle_user_name
    @circle.currency_accounts.each do |ca|
      #don't expose the self player class for a circle user
      if  (circle_player_class.nil? || ca.player_class == circle_player_class) &&
          (ca.user.user_name != circle_user_name || ca.player_class !='self')
        @players << ca
      end
    end
    @players = @players.sort {|a,b| a.user.full_name(true) <=> b.user.full_name(true)}

    @paginate_players = false # !@players.empty?
  end

  def setup_link_players(circle_player_class)
    set_params(:circle_users,true)
    setup_players(circle_player_class)
    key = @search_params['key']
    @users = @players.collect {|p| p.user}
    if !key.blank?
      @users = @users.find_all{|u| u.full_name =~ /#{key}/i || u.user_name =~ /#{key}/i}
    end
    @total_users = @users.size
    @paginate_users = @search_params['paginate'] == 'yes'
    @users = @users.paginate(:page => params[:page],:per_page => params[:per_page]) if @paginate_users
  end

  def setup_players_users(circle_player_class = nil)
    set_params(:circle_users,true)
    setup_users
    setup_players(circle_player_class)
  end
  
  def am_not_namer?
    if namer?
      false
    else
      access_denied
      true
    end
  end
  def namer?
    @current_user_is_namer = @circle.api_user_isa?(current_user,'namer')
  end
  
end
