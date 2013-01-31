class VideoPapersController < ApplicationController
  before_filter :authenticate_any_user!, :except=>[:new,:create,:show]
  before_filter :authenticate_user!, :only=>[:new,:create]
  before_filter :authenticate_owner!, :only=>[:edit,:edit_section,:update,:update_section,:share,:edit_section_duration,:update_setion_duration,:publish,:unpublish,:destroy]
  before_filter :authenticate_shared!, :only=>[:show]
  before_filter :authenticate_admin!, :only=>[:index, :report]
  helper_method :owner_or_admin?
  helper_method :owner?
  
  def index
      order_by = VideoPaper.order_by(params[:order_by])
      @video_papers = VideoPaper.order(order_by).page(params[:page]).per_page(10)
  end
  
  # report that can be pasted from html to google docs
  def report
    rows = [["id", "title", "paper update time", "author", "paper status",  "video update time", "video length", 
       "video private?", "shared with" ]]
    VideoPaper.all.each{|paper| 
      rows << [
        paper.id, paper.title, paper.updated_at, paper.user.name, paper.status,
        paper.video ? paper.video.updated_at : "",
        paper.video ? paper.video.duration : "",
        paper.video ? paper.video.private : "",
        paper.users.map{|u|u.name}.join(', ')
        ]
    }
    render :text => rows.map{|row|row.join("\t")}.join("<br>")
  end
  
  def my_video_papers
    order_by = VideoPaper.order_by(params[:order_by])
    @video_papers = VideoPaper.owned_by(current_user).paginate :page=>params[:page], :per_page=>5, :order=>order_by
  end
  
  def shared_video_papers
    order_by = VideoPaper.order_by(params[:order_by])
    @video_papers = current_user.video_papers.paginate :page=>params[:page], :per_page=>8, :order=>order_by
  end

  def show
    @video_paper = VideoPaper.find(params[:id]) 
    @sections = @video_paper.sections
    @video = @video_paper.video
    
    if @video_paper.unpublished?  && !owner_or_admin?
      redirect_to shared_video_papers_path, :notice=>"this video paper is currently not published."
    end
  end

  def new
    @video_paper = VideoPaper.new
    @video_paper.user = current_user
  end

  def edit
    @video_paper = VideoPaper.find(params[:id])
    @video = @video_paper.video    
  end
  
  def edit_section
    @video_paper = VideoPaper.find(params[:id])
    @section = @video_paper.sections.find_by_title(params[:section])
    @video = @video_paper.video

    # if the section can't be found by title, then use the first
    if @section == nil
      @section = @video_paper.sections.first
    end  
  end

  def create
    @video_paper = VideoPaper.new(params[:video_paper])
    if current_user
      @video_paper.user = current_user
    end

    if @video_paper.save
      case params[:commit]
        when "Enter in notes"
          redirect_to(@video_paper, :notice => "VideoPaper '#{@video_paper.title}' was successfully created.")
        when "Upload a video"
          redirect_to(new_video_paper_video_path(@video_paper),:notice=>"VideoPaper '#{@video_paper.title}' was succesfully created.")
        end
    else
      render :action => "new"
    end
  end

  def update
    @video_paper = VideoPaper.find(params[:id])
    if @video_paper.update_attributes(params[:video_paper])
      case params[:commit]
        when "Enter in notes"
          redirect_to(@video_paper, :notice => 'VideoPaper was successfully updated.')
        when "Upload a video"
          redirect_to(new_video_paper_video_path(@video_paper),:notice=>'VideoPaper was succesfully updated.')
        end
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
    case params[:commit]
      when "Edit Timing"
        redirect_to(:controller=>"video_papers",:action=>"edit_section_duration",:section=>@section.title)
        #render "edit_section_duration"
    else
      @edited_section_url = url_for(@video_paper) + "#" + dom_friend(:id=>@section.title)
      redirect_to(@edited_section_url, :notice => 'VideoPaper was successfully updated.')
    end
  end

  def unshare
    @video_paper = VideoPaper.find(params[:id])
    @shared_users = @video_paper.shared_papers    
    if @video_paper.unshare(params[:user_id])
      respond_to do |format|
        format.js do 
          render :update do |page|
            page.replace_html("shared_user_block",:partial=>"shared_users",:object=>@shared_users)
          end
        end
      end    
    else
      redirect_to share_video_paper_path(@video_paper), :notice=> "ruh-roh"
    end
  end

  def destroy
    @video_paper = VideoPaper.find(params[:id])
    @video_paper.destroy
    redirect_to(my_video_papers_url,:notice=>'VideoPaper was successfully destroyed.') 
  end
  
  def share
    @video_paper = VideoPaper.find(params[:id])
    @shared_users = @video_paper.shared_papers
    @share = SharedPaper.new(params[:shared_paper])
    render :layout=> 'lightbox'
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
      #redirect_to share_video_paper_path(@video_paper),:notice=>"Great Success!"
    else
      #render "share"
    end
    
    respond_to do |format|
      format.js
    end
  end
  
  def edit_section_duration
    @video_paper = VideoPaper.find(params[:id])
    @section = @video_paper.sections.find_by_title(params[:section])
    @video = @video_paper.video

    # if the section can't be found by title, then use the first
    if @section == nil
      @section = @video_paper.sections.first
    end
    
    render :layout => "lightbox"
  end
  
  def update_section_duration
    @video_paper = VideoPaper.find(params[:id])
    @section = @video_paper.sections.find_by_id(params[:section][:id])
    @video = @video_paper.video
  
    if @section.update_attributes(params[:section])
      #redirect_to({:controller=>"video_papers",:action=>"edit_section",:section=>@section.title}, :notice=>"Success!")
      redirect_to(video_paper_path(@video_paper) + "#" + dom_friend(:id=>@section.title),:notice=>'Timing successfully updated.')
    else
      redirect_to(video_paper_path(@video_paper) + "#" + dom_friend(:id=>@section.title),:notice=>'Invalid time!')
    end
  end
  
  def publish
    video_paper = VideoPaper.find(params[:id])
    video_paper.publish!
    redirect_to my_video_papers_url, :notice=> "#{video_paper.title} was sucessfully published!"
  end
  
  def unpublish
    video_paper = VideoPaper.find(params[:id])
    video_paper.unpublish!
    redirect_to my_video_papers_url, :notice=> "#{video_paper.title} was sucessfully unpublished!"
  end
  protected
  def authenticate_owner!
    unless owner_or_admin?
      redirect_to(root_path, :notice => "You aren't authorized for this action.")
    end    
  end
  def authenticate_shared!
    video = VideoPaper.find(params[:id])
    unless owner_or_admin? || video.users.include?(current_user)
      unless current_user
        authenticate_user!
      else
        redirect_to(new_user_session_path, :notice=>"You not permitted to view this page.")
      end
    end
  end
  def owner_or_admin?
    admin? || owner?
  end  
  def admin?
   admin_signed_in?
  end
  def owner?
    current_user == VideoPaper.find(params[:id]).user
  end
end
