class AdminsController < ApplicationController
  before_filter :authenticate_admin!
  def index
    @admins = Admin.all
    @users = User.all
  end

  # NOTE: this is only used by admins so it is safe to lookup by user id instead
  # of invitation_token (which changed in Devise 3)
  # GET /admin_accept_user_invitation?user_id=1
  def accept_user_invitation
    if !request.patch?
      @user = User.find(params[:user_id])
    else
      @user = User.find(params[:user][:id])
      @user.assign_attributes(params[:user])
      @user.accept_invitation!
      redirect_to admin_console_url if @user.errors.empty?
    end
  end

end
