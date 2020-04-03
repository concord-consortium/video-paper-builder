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
      location: url_for(@wysihat_file)
    }

  end

  def show
    # we ought to check if a user should have permission to view this file
    # otherwise people can discover this url and share it with the world
    # but to do that we need to know what paper the file is supposed to be
    # associated with.
    @wysihat_file = WysihatFile.find(params[:id])
    # this is a bit of a hacky way to use the show method
    # it allows us to store the path to this resource in the content
    # instead of the actual url which will be to a an expiring s3 url
    redirect_to @wysihat_file.file.url
  end
end