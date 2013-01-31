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

end
