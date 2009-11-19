class CirclesController < ApplicationController
  # GET /circles
  # GET /circles.xml
  def index
    @circles = Circle.find(:all)
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
    return if am_not_matrice?
  end

  # POST /circles
  # POST /circles.xml
  def create
    Activity
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
    return if am_not_matrice?

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
    return if am_not_matrice?
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
    return if am_not_matrice?
    setup_players_users
  end
  
  # PUT /circles/1/players
  def set_players
    @circle = Currency.find(params[:id])
    return if am_not_matrice?
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
      redirect_to(players_circle_url(@circle)+'?use_session=true&set=true')
    else
      params[:set] = true
      params[:use_session] = true
      setup_players_users
      render :action => 'players'
    end
  end

  # GET /circles/1;currencies
  def currencies
    @circle = Currency.find(params[:id])
    return if am_not_matrice?
    @currencies = []
  end

  # PUT /users/1;set_members
  def set_members
    @circle = Circle.find(params[:id])
    respond_to do |format|
      removal = params.keys.grep(/^remove_(.*)/) {|x| $1}
      if removal.empty?
        l = CircleUserLink.new(:user_id => params[:user_id], :circle_id => @circle.id)
        l.save
      else
        l = CircleUserLink.find(:first, :conditions => ['user_id = ? and circle_id = ?', removal[0], @circle.id])
        l.destroy
      end
      format.html { redirect_to(circle_url(@circle)) }
      format.xml  { head :ok }
    end
  end
  private
  def setup_players_users
    @users = perform_search(OrderPairs,SearchPairs,SearchFormParams,User)
    if (params[:set] && @users.empty?) || (!params[:set] && !params[:search])
      @users = @circle.users.uniq
    end
  end
  def am_not_matrice?
    if @circle.api_user_isa?(current_user,'matrice')
      false
    else
      access_denied
      true
    end
  end
  
end
