class AnnotationsController < ApplicationController
  # GET /annotations
  # GET /annotations.xml
  def index
    authorize! :read, Annotation
    @annotations = Annotation.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @annotations }
    end
  end

  # GET /annotations/1
  # GET /annotations/1.xml
  def show
    authorize! :read, Annotation
    @annotation = Annotation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @annotation }
    end
  end

  # GET /annotations/new
  # GET /annotations/new.xml
  def new
    authorize! :create, Annotation
    @annotation = Annotation.new
    @path = Annotation.map_path(params[:path],params[:query])
    @annotation.path = @path
    session[:annotations_return_to] = request.env['HTTP_REFERER']
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @annotation }
    end
  end

  # GET /annotations/1/edit
  def edit
    authorize! :edit, Annotation
    @annotation = Annotation.find(params[:id])
    session[:annotations_return_to] = request.env['HTTP_REFERER']
  end

  # POST /annotations
  # POST /annotations.xml
  def create
    authorize! :create, Annotation
    @annotation = Annotation.new(params[:annotation])

    respond_to do |format|
      if @annotation.save
        flash[:notice] = 'Annotation was successfully created.'
        return_url = session[:annotations_return_to]
        format.html { redirect_to(return_url) }
        format.xml  { render :xml => @annotation, :status => :created, :location => @annotation }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @annotation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /annotations/1
  # PUT /annotations/1.xml
  def update
    authorize! :edit, Annotation
    @annotation = Annotation.find(params[:id])

    respond_to do |format|
      if @annotation.update_attributes(params[:annotation])
        flash[:notice] = 'Annotation was successfully updated.'
        return_url = session[:annotations_return_to]
        format.html { redirect_to(return_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @annotation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /annotations/1
  # DELETE /annotations/1.xml
  def destroy
    authorize! :delete, Annotation
    @annotation = Annotation.find(params[:id])
    @annotation.destroy

    respond_to do |format|
      format.html { redirect_to(annotations_url) }
      format.xml  { head :ok }
    end
  end
  
end
