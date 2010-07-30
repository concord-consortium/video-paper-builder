class VideosController < ApplicationController
  before_filter :authenticate_any_user!
  before_filter :get_video_paper_and_owner_from_request
  
  def new
  end
  
  protected
  # gets the video paper id from from the parameter, then gets the owner from that paper
  def get_video_paper_and_owner_from_request
    @video_paper = VideoPaper.find(params[:video_paper_id])
    @owner = @video_paper.user
  end
end
