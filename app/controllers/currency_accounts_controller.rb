class CurrencyAccountsController < ApplicationController
  before_filter :set_current_circle
  # GET /currency_accounts
  # GET /currency_accounts.xml
  def index
    @currency_accounts = CurrencyAccount.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @currency_accounts }
    end
  end

  # GET /my_currencies
  # GET /currency_accounts.xml
  def my_currencies
    @currency_accounts = current_user.currency_accounts

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @currency_accounts }
    end
  end

  # GET /dashboard
  # GET /dashboard.xml
  def dashboard
    @currency_accounts = current_user.currency_accounts

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @currency_accounts }
    end
  end

  # GET /currency_accounts/1
  # GET /currency_accounts/1.xml
  def show
    @currency_account = CurrencyAccount.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @currency_account }
    end
  end

  # GET /currency_accounts/new
  # GET /currency_accounts/new.xml
  def new
    @currency_account = CurrencyAccount.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @currency_account }
    end
  end

  # GET /my_currencies/join
  def join_currency
    @currency_account = CurrencyAccount.new
    @joinable_currencies = current_user.joinable_currencies
    respond_to do |format|
      format.html # join_currency.html.erb
      format.xml  { render :xml => @currency_account }
    end
  end

  # POST /my_currencies/join
  def join
    currency_account_params = params[:currency_account]
    currency_id = currency_account_params[:currency_id].to_i
    player_class = currency_account_params[:player_class]
    # if the current user doesn't have the multi-account preference set then
    # we assume the name should just be the current user's user name, otherwise
    # we assume the account name should be prefixed with the user name
    name = (current_user.has_preference('multi_wallet') && current_user.wallets.size > 0) ? currency_account_params[:name] : current_user.user_name
    if Currency.exists?(currency_id)
      @currency = Currency.find(currency_id)
      @currency_account = @currency.api_new_player(player_class,current_user,name)
    else
      @currency_account = CurrencyAccount.new(:name => name,:player_class => player_class,:user_id => current_user.id)
    end
    respond_to do |format|
      if @currency_account.valid?
        flash[:notice] = "You have joined #{@currency.name}"
        format.html { redirect_to( my_currencies_path) }
        format.xml  { render :xml => @currency_account, :status => :created, :location => @currency_account }
      else
        format.html {
          @currency_account.name=currency_account_params[:name]
          @joinable_currencies = current_user.joinable_currencies
          render :action => "join_currency" 
          }
        format.xml  { render :xml => @currency_account.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # GET /currency_accounts/1/edit
  def edit
    @currency_account = CurrencyAccount.find(params[:id])
  end

  # POST /currency_accounts
  # POST /currency_accounts.xml
  def create
    @currency_account = CurrencyAccount.new(params[:currency_account])
    @currency_account.setup
    respond_to do |format|
      if @currency_account.save
        flash[:notice] = "The currency account was created"
        format.html { redirect_to( currency_accounts_path) }
        format.xml  { render :xml => @currency_account, :status => :created, :location => @currency_account }
      else
        format.html { 
          render :action => "new" 
          }
        format.xml  { render :xml => @currency_account.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /currency_accounts/1
  # PUT /currency_accounts/1.xml
  def update
    @currency_account = CurrencyAccount.find(params[:id])

    respond_to do |format|
      if @currency_account.update_attributes(params[:currency_account])
        flash[:notice] = 'The currency account was successfully updated.'
        format.html { redirect_to(currency_accounts_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @currency_account.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /currency_accounts/1
  # DELETE /currency_accounts/1.xml
  def destroy
    @currency_account = CurrencyAccount.find(params[:id])
    if request.env['HTTP_REFERER'] == '/my_currencies'
      flash[:notice] = 'You have left '+@currency_account.currency.name
    end
    @currency_account.destroy
    respond_to do |format|
      format.html { redirect_to(request.env['HTTP_REFERER']) }
      format.xml  { head :ok }
    end
  end

  # GET /currency_accounts/1/history
  def history
    @currency_account = CurrencyAccount.find(params[:id])
    @currency = @currency_account.currency
    @plays = @currency_account.plays
  end
  
  # GET /currency_accounts/1/play
  def play
    @currency_account = CurrencyAccount.find(params[:id])
    @currency = @currency_account.currency

    player_class = @currency_account.player_class
    @play_names = @currency.api_plays.collect {|name,attrs| (!(name =~ /^_/) && attrs[:player_classes] == player_class) ? name : nil}.compact
    @play_name = params[:name]
    if @play_name.blank?
      @play_name = @play_names[0]
    end
    @play = true
  end

  # POST /currency_accounts/1/record_play
  def record_play
    @currency_account = CurrencyAccount.find(params[:id])
    @currency = @currency_account.currency
    @play = params[:play]
    @play_name = params[:play_name]
    @play['from'] = @currency_account
    @currency.api_play_fields(@play_name).each do |field|
      field = field.values[0]
      field_name = field['id']
      next if field_name == 'from'
      field_type = field['type']
      case field_type
      when 'integer','range'
        @play[field_name] = @play[field_name].to_i
      when /^player_/
        if @play[field_name]
          begin
            @play[field_name] = CurrencyAccount.find(@play[field_name])
          rescue Exception => e
            raise "Currency account #{@play[field_name]} not found."
          end
        end
      end
    end
    begin
      @currency.api_play(@play_name,@currency_account,@play)
    rescue Exception => e
      @error = e
    end
    respond_to do |format|
      if !@error
        flash[:notice] = 'The play was recorded.'
        format.html { redirect_to(my_currencies_path) }
        format.xml  { head :ok }
      else
        flash[:notice] = "The play could not be recorded. Error: #{@error}"
        format.html { render :action => "play" }
        format.xml  { render :xml => @currency_account.errors, :status => :unprocessable_entity }
      end
    end
  end
  
end
