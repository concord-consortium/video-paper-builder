class HomeController < ApplicationController
  def index
    
    @user = User.new
    
    if current_user
      # make sure any flashes that got set on the way here are
      # persisted
      flash.keep
      redirect_to new_video_paper_path
    end
  end

  def test_exception
    raise 'This is a test. This is only a test.'
  end

  def about
    @full_width_page = true
  end
  
  def contact
    @full_width_page = true
  end

  def help_videos
    video_name = params[:video_name]
    # remove slashes to prevent someone from trying to hack into other tempates
    video_name.gsub('/','')
    render "help_videos/#{video_name}", :layout => "help_videos"
  end
end
