class VideoPapersController < ApplicationController
  before_filter :authenticate_any_user!, :except=>[:new,:create]
  before_filter :authenticate_user!, :only=>[:new,:create]
  
  # GET /video_papers
  # GET /video_papers.xml
  def index
    @video_papers = VideoPaper.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @video_papers }
    end
  end

  # GET /video_papers/1
  # GET /video_papers/1.xml
  def show
    @video_paper = VideoPaper.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @video_paper }
    end
  end

  # GET /video_papers/new
  # GET /video_papers/new.xml
  def new
    @video_paper = VideoPaper.new
    @video_paper.user = current_user

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @video_paper }
    end
  end

  # GET /video_papers/1/edit
  def edit
    @video_paper = VideoPaper.find(params[:id])
  end

  # POST /video_papers
  # POST /video_papers.xml
  def create
    @video_paper = VideoPaper.new(params[:video_paper])
    if current_user
      @video_paper.user = current_user
    end

    respond_to do |format|
      if @video_paper.save
        format.html { redirect_to(@video_paper, :notice => 'VideoPaper was successfully created.') }
        format.xml  { render :xml => @video_paper, :status => :created, :location => @video_paper }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @video_paper.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /video_papers/1
  # PUT /video_papers/1.xml
  def update
    @video_paper = VideoPaper.find(params[:id])

    respond_to do |format|
      if @video_paper.update_attributes(params[:video_paper])
        format.html { redirect_to(@video_paper, :notice => 'VideoPaper was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @video_paper.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /video_papers/1
  # DELETE /video_papers/1.xml
  def destroy
    @video_paper = VideoPaper.find(params[:id])
    @video_paper.destroy

    respond_to do |format|
      format.html { redirect_to(video_papers_url,:notice=>'VideoPaper was successfully destroyed.') }
      format.xml  { head :ok }
    end
  end

end
