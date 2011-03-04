class CurrenciesController < ApplicationController
  helper :all # include all helpers, all the time

  # GET /currencies
  # GET /currencies.xml
  def index
    return if !can_access_currency?
    conditions = "type != 'CurrencyMembrane'"
    conditions = [conditions+" and steward_id = ?",current_user.id] unless current_user_can?(:admin)
    @currencies = Currency.find(:all,:conditions=>conditions)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @currencies }
    end
  end

  # GET /currencies/1
  # GET /currencies/1.xml
  def show
    @currency = Currency.find(params[:id])
    return if !can_access_currency?(@currency)

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @currency }
    end
  end

  # GET /currencies/new
  # GET /currencies/new.xml
  def new
    return if !can_access_currency?
    check_for_currency_type
    @currency = Currency.new
    setup_current_circle
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @currency }
    end
  end

  # GET /currencies/1/edit
  def edit
    setup_current_circle
    check_for_currency_type
    @currency = Currency.find(params[:id])
    return if !can_access_currency?(@currency)
  end

  # GET /currencies/1/player_classes
  def player_classes
    return if !can_access_currency?
    @currency = Currency.find(params[:id])
    render :partial => "player_classes"
  end

  # POST /currencies
  # POST /currencies.xml
  def create
    return if !can_access_currency?
    params_key = params[:currency_params_key]
    currency_params = get_currency_params
    Currency
    if currency_params[:type].blank?
      # this will end up throwing a "Type can't be blank error later"
      @currency = Currency.new(currency_params)
    else
      @currency = currency_params[:type].constantize.new(currency_params)
      @currency.configuration = params[:config]
    end
    @currency.steward_id = current_user.id
    setup_current_circle
    if @demo_mode
      @current_circle = Currency.find_by_type('CurrencyMembrane')
      @namer_account = @current_circle.api_user_accounts('namer')[0]
      @autojoin = '1'
    elsif @current_circle
      @namer_account = @current_circle.api_user_accounts('namer',current_user)[0]
      raise "You are not a namer in #{@current_circle.name}!" if @namer_account.nil?
      @autojoin = params[:autojoin]
    end
    respond_to do |format|
      if @currency.save
        if @current_circle
          # bind the new currency to the circle if it was declared
          self_account = User.find_by_user_name(@current_circle.circle_user_name).currency_accounts[0]
          play = {
            'from' => @namer_account,
            'to' => self_account,
            'currency' => @currency,
            'autojoin' => @autojoin
          }
          @current_circle.api_play('bind_currency',@namer_account,play)
          #and add all members of the circle to this currency
          @current_circle.api_user_accounts('member').each do |ca|
            play = {
              'from' => @namer_account,
              'to' => ca,
              'currency' => @currency,
              'player_class' => 'member'
            }
            begin
              @current_circle.api_play('grant',@namer_account,play)
            rescue Exception => e
              raise e unless e.to_s =~ /You are allready a member of that currency/
            end            
          end
        end
        flash[:notice] = 'Currency was successfully created.'
        format.html { redirect_to @demo_mode ? dashboard_path : (@current_circle ? currencies_circle_path(@current_circle) : currencies_path) }
        format.xml  { render :xml => @currency, :status => :created, :location => @currency }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @currency.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /currencies/1
  # PUT /currencies/1.xml
  def update
    @currency = Currency.find(params[:id])
    setup_current_circle
    return if !can_access_currency?(@currency)
    currency_params = get_currency_params
    @currency.configuration = params[:config]
#    @currency.type = currency_params[:type]  CANT CHANGE THE CURRENCY TYPE!
    respond_to do |format|
      if @currency.update_attributes(currency_params)
        flash[:notice] = 'Currency was successfully updated.'
        format.html { redirect_to @demo_mode ? dashboard_path : (@current_circle ? currencies_circle_path(@current_circle) : currencies_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @currency.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /currencies/1
  # DELETE /currencies/1.xml
  def destroy
    @currency = Currency.find(params[:id])
    return if !can_access_currency?(@currency)
    @currency.destroy

    respond_to do |format|
      format.html { redirect_to(currencies_url) }
      format.xml  { head :ok }
    end
  end
  
  protected
  def get_currency_params
    params[params[:currency_params_key]]
  end
  def check_for_currency_type
    @currency_type = params[:currency_type]
    if @currency_type
      raise "unknown currency type" if !Currency.types.include?(@currency_type)
      @currency_type = @currency_type.constantize.new
    end
  end
  
  def can_access_currency?(currency = nil)
    return true if current_user_can?(:admin)
    @demo_mode = Configuration.get(:single_circle) == 'on'
    perms_ok = @demo_mode || current_user_can?(:currency)
    if perms_ok && (currency.nil? || currency.steward_id == current_user.id)
      true
    else
      access_denied
      false
    end
  end
  
  def setup_current_circle
    set_current_circle(false)
    @circle = @current_circle
    if @current_circle
      @current_user_is_namer = @current_circle.api_user_isa?(current_user,'namer')
    end
  end
  
end
