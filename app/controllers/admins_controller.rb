class AdminsController < ApplicationController
  before_filter :authenticate_admin!
  def index
    @admins = Admin.all
    @users = User.all
  end

  # GET /admin_accept_user_invitation?invitation_token=abcdef
  def accept_user_invitation
    if !request.put?
      @user = User.find_by_invitation_token params[:invitation_token]
    else
      @user = User.accept_invitation!(params[:user])
      redirect_to admin_console_url
    end
  end

end
