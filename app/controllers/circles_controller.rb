class CirclesController < ApplicationController
  before_filter :set_current_circle,:only => :members
  # GET /circles
  # GET /circles.xml
  def index
    @membranes = Currency.find(:all,:conditions => "type = 'CurrencyMembrane'",:include => :currency_accounts)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @circles }
    end
  end

  # GET /circles/1
  # GET /circles/1.xml
  def show
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
    @circle = Currency.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @circle }
    end
  end

  # GET /circles/1/edit
  def edit
    @circle = Currency.find(params[:id])
    return if am_not_namer?
  end

  # POST /circles
  # POST /circles.xml
  def create
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
    @circle = Currency.find(params[:id])
    return if am_not_namer?

    respond_to do |format|
      if @circle.errors.empty? && @circle.update_attributes(params[:circle])
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
    @circle = Currency.find(params[:id])
    return if am_not_namer?
    circle_user = User.find_by_user_name(circle_user_name(@circle.name))
    circle_user.destroy if !circle_user.nil?
    @circle.destroy
    respond_to do |format|
      format.html { redirect_to(circles_url) }
      format.xml  { head :ok }
    end
  end

  # GET /circles/1/players
  def players
    @circle = Currency.find(params[:id])
    return if am_not_namer?
    setup_players_users
  end
  
  # PUT /circles/1/players
  def set_players
    @circle = Currency.find(params[:id])
    return if am_not_namer?
    player_class = params[:player_class]
    if player_class.blank?
      @circle.errors.add_to_base('You must choose a role!')
    end
    if !params[:users]
      @circle.errors.add_to_base('You must choose some users!')
    end
    if @circle.errors.empty?
      params[:users].keys.each do |user_id|
        user = User.find(user_id)
        @circle.add_player_to_circle(player_class,user)
      end
      flash[:notice] = 'Circle was successfully updated.'
      redirect_to(players_circle_url(@circle))
    else
      setup_players_users
      render :action => 'players'
    end
  end

  # GET /circles/1/currencies
  def currencies
    @circle = Currency.find(params[:id])
    return if am_not_namer?
    setup_bound_currencies
  end
  
  # PUT /circles/1/currencies
  def set_currencies
    @circle = Currency.find(params[:id])
    return if am_not_namer?
    if !params[:currencies]
      @circle.errors.add_to_base('You must choose some currencies!')
    end
    if @circle.errors.empty?
      params[:currencies].keys.each do |currency_id|
        currency = Currency.find(currency_id)
        self_account = User.find_by_user_name(@circle.circle_user_name).currency_accounts[0]
        #TODO, this needs updating if the same user can have multiple accounts in the same currency as namer
        namer_account = @circle.api_user_accounts('namer',current_user)[0]
        
        play = {
          'from' => namer_account,
          'to' => self_account,
          'currency' => currency
        }
        @circle.api_play('bind_currency',namer_account,play)
      end
      flash[:notice] = 'Circle was successfully updated.'
      redirect_to(currencies_circle_url(@circle))
    else
      setup_players_users
      render :action => 'currencies'
    end
  end
  #GET /circles/members
  def members
    @users = @current_circle.api_user_accounts('member').collect{|ca| ca.user}.uniq
  end
  
  private
  def setup_bound_currencies
    set_params(:circle_currencies,true)
    key = @search_params['key']
    if key.blank?
      @currencies = Currency.find(:all,:conditions=> "type != 'CurrencyMembrane'")
    else
      key = '%'+key+'%'
      @currencies = Currency.find(:all,:conditions=>["type != 'CurrencyMembrane' and (name #{ILIKE} ?)",key])
    end
    @bound_currencies = @circle.currencies
    @currencies = @currencies - @bound_currencies
    @currencies = @currencies.paginate(:page => @search_params[:page])
    @paginate_bound_currencies = false # !@bound_currencies.empty?
  end
  def setup_players_users
    set_params(:circle_users,true)
#    @users = perform_search(OrderPairs,SearchPairs,SearchFormParams,User)
    key = @search_params['key']
    if key.blank?
      @users = User.find(:all)
    else
      key = '%'+key+'%'
      @users = User.find(:all,:conditions=>["#{SQL_FULL_NAME} #{ILIKE} ? or user_name #{ILIKE} ?",key,key])
    end
    @total_users = User.count
    @users = @users.reject {|u| u.user_name == @circle.circle_user_name}
    @users ||=[]
    @users = @users.paginate(:page => @search_params[:page])
    @players = @circle.users.uniq.reject {|u| u.user_name == @circle.circle_user_name}
    @paginate_players = false # !@players.empty?
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
