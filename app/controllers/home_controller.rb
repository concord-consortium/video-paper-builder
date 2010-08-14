class HomeController < ApplicationController
  def index
    
    @user = User.new
    
    if current_user
      redirect_to new_video_paper_path
    end
  end

end
