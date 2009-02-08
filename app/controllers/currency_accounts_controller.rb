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

  # GET /currency_accounts/1/edit
  def edit
    @currency_account = CurrencyAccount.find(params[:id])
  end

  # POST /currency_accounts
  # POST /currency_accounts.xml
  def create
    @currency_account = CurrencyAccount.new(params[:currency_account])

    respond_to do |format|
      if @currency_account.save
        flash[:notice] = 'CurrencyAccount was successfully created.'
        format.html { redirect_to( currency_accounts_path) }
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
        flash[:notice] = 'CurrencyAccount was successfully updated.'
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
    @currency_account.destroy

    respond_to do |format|
      format.html { redirect_to(currency_accounts_url) }
      format.xml  { head :ok }
    end
  end
end
