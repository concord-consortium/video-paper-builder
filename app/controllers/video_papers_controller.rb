class VideoPapersController < ApplicationController
  before_filter :authenticate_any_user!, :except=>[:new,:create,:show]
  before_filter :authenticate_user!, :only=>[:new,:create]
  before_filter :authenticate_owner!, :only=>[:edit,:update,:share]
  before_filter :authenticate_shared!, :only=>[:show]
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
  
  def share
    @video_paper = VideoPaper.find(params[:id])
    @shared_users = @video_paper.shared_papers
    @share = SharedPaper.new
  end
  
  def shared
    @video_paper = VideoPaper.find(params[:id])
    @shared_users = @video_paper.shared_papers
    @share = SharedPaper.new(params[:shared_paper])
    
    
    user = User.find_by_email(params[:shared_paper][:user_id])
    @shared_paper = SharedPaper.new
    @shared_paper.user = user
    @shared_paper.video_paper = @video_paper
    @shared_paper.notes = params[:shared_paper][:notes]
    
    if @shared_paper.save
      redirect_to video_papers_url,:notice=>"word"
    else
      render "share"
    end
  end
  
  protected
  def authenticate_owner!
    unless owner_or_admin
      redirect_to(root_path, :notice => "You aren't authorized for this action.")
    end    
  end
  def authenticate_shared!
    logger.info("RAWR #{VideoPaper.find(params[:id]).users.include?(current_user)} \n")
    logger.info("OWNER_OR_ADMIN #{owner_or_admin == true}")
    unless owner_or_admin || VideoPaper.find(params[:id]).users.include?(current_user)
      logger.info("I GET HERE \n")
      unless current_user
        authenticate_user!
      else
        redirect_to(new_user_session_path, :notice=>"You not permitted to view this page.")
      end
    end
  end
  def owner_or_admin
    owner = VideoPaper.find(params[:id]).user
    if admin || owner == current_user
      true
    else
      false
    end
  end  
  def admin
    if current_admin
      true
    else
      false
    end
  end
end
