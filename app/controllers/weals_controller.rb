class WealsController < ApplicationController
  require_authorization
  include Lister
  before_filter :determine_weal_type
  # GET /weals
  # GET /weals.xml
  def index
    load_weals
    respond_to do |format|
      format.html do
        render :template => "weals/index_#{@type}"
      end
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
    render :template => "weals/edit_#{@type}"
  end

  # POST /weals
  # POST /weals.xml
  def create
    setup_save_attributes
    @weal = Weal.new(@save_attributes)
    prepare_for_save  
    respond_to do |format|
      if @weal.save
        finalize_save
        flash[:notice] = 'Your intention was placed.'
        format.html { redirect_to index_url }
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
    setup_save_attributes
    prepare_for_save
    respond_to do |format|
      if @weal.update_attributes(@save_attributes)
        finalize_save
        flash[:notice] = (@type == :intention ? 'Intention' : 'Weal') + ' was successfully updated.'
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

    if params[:as]
      @save_attributes[:fulfiller_id] = (params[:as]  == 'fulfiller') ? current_user.id : nil
      @save_attributes[:requester_id] = (params[:as]  == 'requester') ? current_user.id : nil
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
  end

  def load_weals
    if @type == :intentions
      @weals = current_user.intentions
    else
      def_sort_rules(* [['r','lft,users.last_name,users.first_name,weals.created_at'],['d','lft,weals.created_at']])

      def_search_rules(:sql,[['t','title'],['d','description']])
      def_search_rule 'base' do |search_for|
        ["phase = 'intention' and requester_id is not null and fulfiller_id is null"]
      end
      def_search_rule 'full' do |search_for|
        s = "%#{search_for}%"
        ["#{SQL_FULL_NAME} #{ILIKE} ? or description #{ILIKE} ? or title #{ILIKE} ?",s,s,s]
      end
      def_search_rule 'requester' do |search_for|
        ["#{SQL_FULL_NAME} #{ILIKE} ?","%#{search_for}%"]
      end
      set_params(:user,params[:use_session],:order_current => 'd',:paginate => 'yes')
      @search_params.update({'on_base' => 'base', 'for_base' => 'dummy'})
      sql_options = get_sql_options.update({:include => :requester})
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
  end
  
  def load_currencies
    Currency.find(:all)
  end
  
  def determine_weal_type
    request.path =~ /^\/([^\/]*)/
    @type = $1.to_sym
  end
  
  def index_url(params=nil)
    case @type
    when :intentions
      intentions_url
    when :requests
      requests_url
    else
      weals_url
    end
  end
  
end
