class VideosController < ApplicationController
  before_filter :authenticate_any_user!
  before_filter :get_video_paper_and_owner_from_request
  before_filter :authenticate_owner!  
  
  def new
    @video = Video.new
  end
  
  def create
    if (@owner == current_user ) || current_admin 
      @video = Video.new(params[:video])
      
      unless @video.video_paper
        @video.video_paper = @video_paper
      end
      
      if @video.save
        redirect_to(@video_paper,:notice=>"Your video was successfully updated!")
      else
        render :action => new
      end
    else
      redirect_to( root_path,:notice=>"You are not authorized to add a video to this Video Paper.")
    end
  end
  
  protected
  # gets the video paper id from from the parameter, then gets the owner from that paper
  def get_video_paper_and_owner_from_request
    @video_paper = VideoPaper.find(params[:video_paper_id])
    @owner = @video_paper.user
  end
  
  def authenticate_owner!
    unless owner_or_admin
      redirect_to(root_path, :notice => "You aren't authorized for this action.")
    end    
  end
  
  def owner_or_admin
    (@owner == current_user && current_user) || current_admin
  end
end
