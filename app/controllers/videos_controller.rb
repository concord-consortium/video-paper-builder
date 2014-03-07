class VideosController < ApplicationController
  before_filter :authenticate_any_user!
  before_filter :get_video_paper_and_owner_from_request
  before_filter :authenticate_owner!  
  before_filter :authenticate_admin!, :only=>[:show]
  before_filter :video_exists?, :only=>[:new,:create]
  before_filter :no_video?,:only=>[:index]
  
  def index
    @video = @video_paper.video
  end

  def show
    @video = Video.find(params[:id])

    if @video.entry_id
      @kaltura_info = KalturaFu.get_video_info(@video.entry_id)
    end
  end

  def new
    @video = Video.new
    # make videos public by default because of confusing UI
    @video.private = false
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
    KalturaFu.generate_session_key    
  end
  def update
    @video = Video.find(params[:id])
    old_entry = @video.entry_id    
    if @video.update_attributes(params[:video])
      unless params[:video][:entry_id] == old_entry
        @video.processed = false
        @video.duration = nil
        @video.save
      end
      redirect_to( my_video_papers_path,
        :notice=>"Your video was sucessfully updated!"
      )
    else 
      render "edit"
    end
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
  def no_video?
    unless @video_paper.video
      redirect_to( new_video_paper_video_path(@video_paper),
        :notice=>"You should start by making a video!"
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
