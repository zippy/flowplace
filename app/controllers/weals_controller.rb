class WealsController < ApplicationController
  require_authorization
  # GET /weals
  # GET /weals.xml
  def index
    @weals = load_weals
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @weals }
    end
  end

  # GET /weals/1
  # GET /weals/1.xml
  def show
    @weal = Weal.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @weal }
    end
  end

  # GET /weals/new
  # GET /weals/new.xml
  def new
    @weal = Weal.new
    @currencies = load_currencies

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @weal }
    end
  end

  # GET /weals/1/edit
  def edit
    @weal = Weal.find(params[:id])
    @currencies = load_currencies
    render :template => 'weals/edit_intention' if request.request_uri =~ /\/intentions/
  end

  # POST /weals
  # POST /weals.xml
  def create
    @weal = Weal.new(params[:weal])
    @weal.fulfiller_id = current_user.id if params[:as] == 'fulfiller'
    @weal.requester_id = current_user.id if params[:as] == 'requester'
    @weal.tag_list = params[:tags]
    respond_to do |format|
      if @weal.save
        handle_extras
        flash[:notice] = 'Your intention was placed.'
        format.html { redirect_to weals_url(:use_session => true) }
        format.xml  { render :xml => @weal, :status => :created, :location => @weal }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @weal.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /weals/1
  # PUT /weals/1.xml
  def update
    @weal = Weal.find(params[:id])
    if params[:as]
      @weal.fulfiller_id = (params[:as]  == 'fulfiller') ? current_user.id : nil
      @weal.requester_id = (params[:as]  == 'requester') ? current_user.id : nil
    end
    @weal.tag_list = params[:tags]
    respond_to do |format|
      if @weal.update_attributes(params[:weal])
        handle_extras
        flash[:notice] = (params[:as] ? 'Intention' : 'Weal') + ' was successfully updated.'
        format.html { redirect_to weals_url(:use_session => true) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @weal.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /weals/1
  # DELETE /weals/1.xml
  def destroy
    @weal = Weal.find(params[:id])
    @weal.destroy

    respond_to do |format|
      format.html { redirect_to(weals_url) }
      format.xml  { head :ok }
    end
  end
  private

  def handle_extras
    parent_id = params[:extras][:required_id] if params[:extras]
    @weal.move_to_child_of(parent_id) if parent_id && Weal.exists?(parent_id)
    params[:currencies].each do |currency_id,value|
      exists  = @weal.currencies.exists?(currency_id)
      if value == '1'
        @weal.currencies << Currency.find(currency_id)  if !exists
        link = @weal.currency_weal_links.find(:first,:conditions => ["currency_id = ?",currency_id])
        link.link_spec = params[:currencies]["#{currency_id}_val"]
        link.save
      else
        @weal.currencies.delete(Currency.find(currency_id)) if exists
      end
    end
  end

  def load_weals
    Weal.find(:all,:order => :lft)
  end
  
  def load_currencies
    Currency.find(:all)
  end
  
end
