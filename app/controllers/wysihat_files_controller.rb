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
        url: url_for(@wysihat_file)
      }
    }, content_type: "text/html"

  end

  def show
    @wysihat_file = WysihatFile.find(params[:id])
    # this is a bit of a hacky way to use the show method
    # it allows us to store the path to this resource in the content
    # instead of the actual url which will be to a an expiring s3 url
    redirect_to @wysihat_file.file.url
  end
end