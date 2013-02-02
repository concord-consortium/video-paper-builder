class WysihatFilesController < ApplicationController
  def index
    @wysihat_file, @wysihat_files = WysihatFile.new, current_user.wysihat_files
    render :layout => false
  end

  def create
    @wysihat_file = WysihatFile.new
    @wysihat_file.file = params[:file]
    @wysihat_file.user = current_user
    @wysihat_file.save

    render json: {
      image: {
        url: @wysihat_file.file.url
      }
    }, content_type: "text/html"

  end

end