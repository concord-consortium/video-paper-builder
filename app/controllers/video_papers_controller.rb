class VideoPapersController < ApplicationController
  before_filter :authenticate_any_user!, :except=>[:new,:create,:show]
  before_filter :authenticate_user!, :only=>[:new,:create]
  before_filter :authenticate_owner!, :only=>[:edit,:edit_section,:update,:update_section,:share]
  before_filter :authenticate_shared!, :only=>[:show,]
  helper_method :owner_or_admin

  def index
    @video_papers = VideoPaper.all
  end

  def show
    @video_paper = VideoPaper.find(params[:id]) 
    @sections = @video_paper.sections
  end

  def new
    @video_paper = VideoPaper.new
    @video_paper.user = current_user
  end

  def edit
    @video_paper = VideoPaper.find(params[:id])
  end
  
  def edit_section
    @video_paper = VideoPaper.find(params[:id])
    @section = @video_paper.sections.find_by_title(params[:section])

    # if the section can't be found by title, then use the first
    if @section == nil
      @section = @video_paper.sections.first
    end
    
    render :template => 'sections/edit_sections', :section => @section
  end

  def create
    @video_paper = VideoPaper.new(params[:video_paper])
    if current_user
      @video_paper.user = current_user
    end

    if @video_paper.save
      redirect_to(@video_paper, :notice => 'VideoPaper was successfully created.')
    else
      render :action => "new"
    end
  end

  def update
    @video_paper = VideoPaper.find(params[:id])
    if @video_paper.update_attributes(params[:video_paper])
      redirect_to(@video_paper, :notice => 'VideoPaper was successfully updated.')
    else
      render :action => "edit" 
    end
  end
  
  def update_section
    @video_paper = VideoPaper.find(params[:id])
    @section = @video_paper.sections.find_by_title(params[:section][:title])
    @section.content = params[:section][:content]
    @section.save!
    #Redirect user to the section they just updated
    #TODO: is there a better way to incorporate dom_friend here?
    @edited_section_url = url_for(@video_paper) + "#" + dom_friend(:id=>@section.title)
    redirect_to(@edited_section_url, :notice => 'VideoPaper was successfully updated.')
  end

  def unshare
    @video_paper = VideoPaper.find(params[:id])
    if @video_paper.unshare(params[:user_id])
      redirect_to share_video_paper_path(@video_paper), :notice=> "Removed User from shared list."
    else
      redirect_to share_video_paper_path(@video_paper), :notice=> "ruh-roh"
    end
  end

  def destroy
    @video_paper = VideoPaper.find(params[:id])
    @video_paper.destroy
    redirect_to(video_papers_url,:notice=>'VideoPaper was successfully destroyed.') 
  end
  
  def share
    @video_paper = VideoPaper.find(params[:id])
    @shared_users = @video_paper.shared_papers
    @share = SharedPaper.new(params[:shared_paper])
  end
  
  def shared
    @video_paper = VideoPaper.find(params[:id])
    @shared_users = @video_paper.shared_papers
    @share = SharedPaper.new(params[:shared_paper])
    
    shared_paper = params[:shared_paper]
    #massage the attributes into an acceptable format for the share method
    user = User.find_by_email(params[:shared_paper][:user_id])
    unless user.nil?
      shared_paper[:user_id] = user.id
    end
    @share = @video_paper.share(shared_paper)
    if @share
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
    unless owner_or_admin || VideoPaper.find(params[:id]).users.include?(current_user)
      unless current_user
        authenticate_user!
      else
        redirect_to(new_user_session_path, :notice=>"You not permitted to view this page.")
      end
    end
  end
  def owner_or_admin
    retval = false
    owner = VideoPaper.find(params[:id]).user
    retval = true if admin || owner == current_user
    retval
  end  
  def admin
    retval = false
    retval = true if current_admin
    retval
  end
end
