class CurrencyAccountsController < ApplicationController
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

  # GET /currency_accounts/1/edit
  def edit
    @currency_account = CurrencyAccount.find(params[:id])
  end

  # POST /currency_accounts
  # POST /currency_accounts.xml
  def create
    currency_account_params = params[:currency_account]
    notice = ''
    @currency = Currency.find(currency_account_params[:currency_id])
    if currency_account_params[:user_id].blank?
      notice = "You have joined #{@currency.name}"
      redirect_url = my_currencies_path
      currency_account_params[:user_id] = current_user.id
    else
      notice = "The currency account was created"
      redirect_url = currency_accounts_path
    end
    @currency_account = CurrencyAccount.new(currency_account_params)
    @currency_account.setup
    respond_to do |format|
      if @currency_account.save
        flash[:notice] = notice
        format.html { redirect_to( redirect_url) }
        format.xml  { render :xml => @currency_account, :status => :created, :location => @currency_account }
      else
        format.html { render :action => "new" }
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
  
  # GET /currency_accounts/1/play
  def play
    @currency_account = CurrencyAccount.find(params[:id])
    @currency = @currency_account.currency
  end

  # POST /currency_accounts/1/record_play
  def record_play
    @currency_account = CurrencyAccount.find(params[:id])
    @currency = @currency_account.currency
    @play = params[:play]
    @play_name = params[:play_name]
    @play['from'] = @currency_account
    @currency.api_play_fields(@play_name).each do |field|
      field_name = field.keys[0]
      next if field_name == 'from'
      field_type = field.values[0]
      case field_type
      when 'integer'
        @play[field_name] = @play[field_name].to_i
      when /^player_/
        if @play[field_name]
          @play[field_name] = CurrencyAccount.find(@play[field_name])
        end
      end
    end
    
    @currency.api_play(@play_name,@currency_account,@play)
    respond_to do |format|
      if true
        flash[:notice] = 'The play was recorded.'
        format.html { redirect_to(my_currencies_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "play" }
        format.xml  { render :xml => @currency_account.errors, :status => :unprocessable_entity }
      end
    end
  end
  
end
