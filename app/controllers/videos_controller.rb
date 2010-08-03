class VideosController < ApplicationController
  before_filter :authenticate_any_user!
  before_filter :get_video_paper_and_owner_from_request
  before_filter :authenticate_owner!  
  before_filter :video_exists?, :only=>[:new,:create]
  
  def new
    @video = Video.new
    KalturaFu.generate_session_key
  end
  
  def create
    if owner_or_admin
      @video = Video.new(params[:video])
      unless @video.video_paper_id
        @video.video_paper = @video_paper
      end
      
      if @video.save
        redirect_to(@video_paper,:notice=>"Your video was successfully updated!")
      else
        render "new"
        #redirect_to(new_video_paper_video_path(@video_paper))
      end
    else
      redirect_to( root_path,:notice=>"You are not authorized to add a video to this Video Paper.")
    end
  end
  
  def edit
    @video = Video.find(params[:id])
  end
  def update
    @video = Video.find(params[:id])
  end
  
  protected
  # gets the video paper id from from the parameter, then gets the owner from that paper
  def get_video_paper_and_owner_from_request
    @video_paper = VideoPaper.find(params[:video_paper_id])
    @owner = @video_paper.user
  end
  def video_exists?
    if @video_paper.video
      redirect_to( edit_video_paper_video_path(@video_paper,@video_paper.video),
        :notice=>"You already have a video, you can edit it instead!"
      )
    end
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
