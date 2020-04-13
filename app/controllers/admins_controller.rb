class AdminsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @admins = Admin.all
    @users = User.all
  end

  def destroy
    @admin = Admin.find(params[:id])
    @admin.destroy
    redirect_to(admins_path,:notice=>"Admin: #{@admin.name} was removed.")
  end

  # NOTE: this is only used by admins so it is safe to lookup by user id instead
  # of invitation_token (which changed in Devise 3)
  # GET /admin_accept_user_invitation?user_id=1
  def accept_user_invitation
    if !request.patch?
      @user = User.find(params[:user_id])
    else
      @user = User.find(params[:user][:id])
      @user.assign_attributes(user_params(params[:user]))
      @user.accept_invitation!
      redirect_to admin_console_url if @user.errors.empty?
    end
  end

  private

  def user_params(_params)
    params = _params
    params.permit(:email, :password, :password_confirmation, :first_name, :last_name,:invitation_token, :provider, :uid, :remember_me)
  end

end
