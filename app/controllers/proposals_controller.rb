class ProposalsController < ApplicationController
  # GET /proposals
  # GET /proposals.xml
  def index
    @proposals = Proposal.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @proposals }
    end
  end

  # GET /proposals/1
  # GET /proposals/1.xml
  def show
    @proposal = Proposal.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @proposal }
    end
  end

  # GET /proposals/new
  # GET /proposals/new.xml
  def new
    @proposal = Proposal.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @proposal }
    end
  end

  # GET /proposals/1/edit
  def edit
    @proposal = Proposal.find(params[:id])
  end

  # POST /proposals
  # POST /proposals.xml
  def create
    Activity
    @proposal = Proposal.new(params[:proposal])

    respond_to do |format|
      if @proposal.save
        IntentionActivity.add(@proposal.user,@proposal.weal,'made a proposal to')
        flash[:notice] = 'Proposal was successfully created.'
        format.html { redirect_after_save }
        format.xml  { render :xml => @proposal, :status => :created, :location => @proposal }
      else
        format.html do
          if params[:source]
            flash[:notice] = "Please enter the text of your proposal!"
            redirect_to(params[:source])
          else
            render :action => "new"
          end
        end
        format.xml  { render :xml => @proposal.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /proposals/1
  # PUT /proposals/1.xml
  def update
    @proposal = Proposal.find(params[:id])
    if params['commit'] == "Withdraw Proposal"
      @proposal.destroy
      flash[:notice] = 'Proposal was withdrawn.'
      redirect_after_save
    else
      respond_to do |format|
        if @proposal.update_attributes(params[:proposal])
          flash[:notice] = 'Proposal was successfully updated.'
          format.html { redirect_after_save }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @proposal.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /proposals/1
  # DELETE /proposals/1.xml
  def destroy
    @proposal = Proposal.find(params[:id])
    @proposal.destroy

    respond_to do |format|
      format.html { redirect_to(proposals_url) }
      format.xml  { head :ok }
    end
  end
  private
  def redirect_after_save
    if params[:redirect]
      redirect_to(params[:redirect])
    else
      redirect_to(proposals_url)
    end
  end
end
