class WealsController < ApplicationController
  require_authorization
  include Lister
  before_filter :determine_weal_phase_from_url
  # GET /weals|intentions|actions|assets
  # GET /weals.xml
  def index
    load_weals
    respond_to do |format|
      format.html do
        render :template => "weals/index_#{@phase}s"
      end
      format.xml  { render :xml => @weals }
    end
  end

  # GET /weals|intentions|actions|assets/my
  def my
    load_my_weals
    respond_to do |format|
      format.html do
        render :template => "weals/index_#{@phase}s"
      end
      format.xml  { render :xml => @weals }
    end
  end

  # GET /intentions/proposed
  def proposed
    @proposed = true
    @weals = current_user.proposed_intentions
    respond_to do |format|
      format.html do
        render :template => "weals/index_#{@phase}s"
      end
      format.xml  { render :xml => @weals }
    end
  end

  # GET /weals/1
  # GET /weals/1.xml
  def show
    @is_view = true
    @weal = Weal.find(params[:id])

    respond_to do |format|
      format.html do
        render :template => "weals/show_#{@phase}"
      end
      format.xml  { render :xml => @weal }
    end
  end

  # GET /weals/new
  # GET /weals/new.xml
  def new
    @weal = Weal.new
    @currencies = load_currencies

    respond_to do |format|
      format.html do
        render :template => "weals/new_#{@phase}"
      end
      format.xml  { render :xml => @weal }
    end
  end

  # GET /weals/1/edit
  def edit
    @is_edit = true
    @weal = Weal.find(params[:id])
    @proposals = @weal.proposals
    @currencies = load_currencies
    if @weal.requester == current_user
      @holding_as = 'requester'
      @other_holding_as = 'offerer'
      @other_party = @weal.offerer
    end
    if @weal.offerer == current_user
      @holding_as = 'offerer'
      @other_holding_as = 'requester'
      @other_party = @weal.requester
    end
    render :template => "weals/edit_#{@phase}s"
  end

  # POST /weals|intentions
  # POST /weals.xml
  def create
    Activity
    setup_save_attributes
    @weal = Weal.new(@save_attributes)
    prepare_for_save 
    respond_to do |format|
      if @weal.save
        finalize_save
        IntentionActivity.add(current_user,@weal,'created')
        flash[:notice] = 'Your '+humanize_phase+' was declared.'
        format.html { redirect_to index_url }
        format.xml  { render :xml => @weal, :status => :created, :location => @weal }
      else
        @currencies = load_currencies
        format.html { render :action => "weals/new_#{@phase}" }
        format.xml  { render :xml => @weal.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /weals/1
  # PUT /weals/1.xml
  def update
    @weal = Weal.find(params[:id])
    setup_save_attributes
    prepare_for_save
    respond_to do |format|
      if @weal.update_attributes(@save_attributes)
        finalize_save
        flash[:notice] = humanize_phase.titleize + ' was successfully updated.'
        format.html { redirect_to index_url }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @weal.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /phaseshift/1
  # PUT /phaseshift/1.xml
  def phaseshift
    @weal = Weal.find(params[:id])
    @save_attributes = {}
    case @weal.phase
    when 'intention'
      proposer = @save_attributes['offerer_id'] = params[:weal]['offerer_id'] if params[:weal].has_key?('offerer_id')
      proposer = @save_attributes['requester_id'] = params[:weal]['requester_id'] if params[:weal].has_key?('requester_id')
      @save_attributes['phase'] = 'action'
      proposer = User.find(proposer)
      proposal = proposer.proposals.find(:first, :conditions => ['weal_id = ?',@weal.id])
      notes = @weal.notes
      notes += "\n" if notes
      notes ||= ''
      @save_attributes['notes'] =  notes + "\nAccepted proposal was: #{proposal.description}"
    when 'action'
      @save_attributes['phase'] = 'asset'
    else
      raise "not implemented"
    end

    respond_to do |format|
      if @weal.update_attributes(@save_attributes)
        flash[:notice] = "Phase shift to #{@save_attributes['phase']} was successful."
        format.html { redirect_to index_url }
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
      format.html { redirect_to(index_url) }
      format.xml  { head :ok }
    end
  end
  
  private

  def setup_save_attributes
    @save_attributes = params[:weal]
    @save_parent_id =  @save_attributes.has_key?(:parent_id)
    @parent_id = @save_attributes[:parent_id]
    @save_attributes.delete(:parent_id)
    @save_attributes[:in_service_of] = @save_attributes[:in_service_of].join(',')
    
    if params[:as]
      @save_attributes[:offerer_id] = (params[:as]  == 'offerer') ? current_user.id : nil
      @save_attributes[:requester_id] = (params[:as]  == 'requester') ? current_user.id : nil
      @save_attributes[:created_by_requester] = !@save_attributes[:requester_id].nil?
    end
  end

  def prepare_for_save
    @weal.tag_list = params[:tags]
  end

  def finalize_save
    if @save_parent_id
      if @parent_id && Weal.exists?(@parent_id)
        @weal.move_to_child_of(@parent_id)
      else
        @weal.move_to_right_of(@weal.parent) if @weal.parent
      end
    end
    if params[:currencies]
      params[:currencies].each do |currency_id,values|
        exists  = @weal.currencies.exists?(currency_id)
        if values['used'] == '1'
          @weal.currencies << Currency.find(currency_id)  if !exists
          link = @weal.currency_weal_links.find(:first,:conditions => ["currency_id = ?",currency_id])
          link.link_spec = values['val']
          link.save
        else
          @weal.currencies.delete(Currency.find(currency_id)) if exists
        end
      end
    end
  end

  def load_my_weals
    case @phase
    when :intention
      @weals = current_user.intentions
    when :action
      @weals = current_user.actions
    when :asset
      @weals = current_user.assets
    else
      raise "unknown weal phase!"
    end
  end

  def load_weals
    case @phase
    when :intention
      @weals = Weal.find(:all,:conditions=>"phase ='intention'")
      return
    when :action
      @weals = Weal.find(:all,:conditions=>"phase ='action'")
      return
    when :asset
      @weals = Weal.find(:all,:conditions=>"phase ='asset'")
      return
    end
    def_sort_rules(* [['r','lft,users.last_name,users.first_name,weals.created_at'],['d','lft,weals.created_at']])

    def_search_rules(:sql,[['t','title'],['d','description']])
    def_search_rule 'base' do |search_for|
      ["phase = 'intention'"]
    end
    def_search_rule 'full' do |search_for|
      s = "%#{search_for}%"
      ["#{SQL_FULL_NAME} #{ILIKE} ? or description #{ILIKE} ? or title #{ILIKE} ?",s,s,s]
    end
    def_search_rule 'as_name' do |search_for|
      ["#{SQL_FULL_NAME} #{ILIKE} ?","%#{search_for}%"]
    end
    def_search_rule 'as' do |search_for|
      case search_for
      when 'requester'
        ['requester_id is not null and offerer_id is null']
      when 'offerer'
        ['offerer_id is not null and requester_id is null']
      end
    end
    set_params(:user,params[:use_session],:order_current => 'd',:paginate => 'yes')
    @search_params.update({'on_base' => 'base', 'for_base' => 'dummy','on_as' => 'as'})
    @search_params["for_as"] ||= 'requester'
    sql_options = get_sql_options.update({:include => @search_params[:for_as]})
#      raise sql_options.inspect
    if sql_options[:conditions] || @display_all
      if @search_params[:paginate]=='yes'
        @weals = Weal.paginate(:all,sql_options.update({:page => @search_params[:page]}))
      else
        @weals = Weal.find(:all,sql_options)
      end
    else
      @weals = []
    end
  end
  
  def load_currencies
    Currency.find(:all)
  end
  
  def determine_weal_phase_from_url
    request.path =~ /^\/([^\/]*)s/
    @phase = $1.to_sym
  end
  
  def humanize_phase
    "#{@phase}"
  end

  def index_url(params=nil)
    case @phase
    when :asset
      my_assets_url
    when :action
      my_actions_url
    when :intention
      my_intentions_url
    else
      weals_url
    end
  end
  
end
