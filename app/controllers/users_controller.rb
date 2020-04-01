class UsersController < ApplicationController
  before_action :authenticate_admin!, :except => [ :login_for_test]

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to(admins_path,:notice=>"User: #{@user.name} was removed.")
  end

  # a special action to speed up tests, the route for this is only enabled in cucumber environment
  def login_for_test
    user = User.find params[:id]
    sign_in(user)
    render :plain => "OK"
  end

  def index
    respond_to do |format|
       format.csv { render :csv => User.limit(500)}
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params(params[:user]))
      redirect_to admin_console_path, :notice => "User was update successfully"
    else
      render :action => 'edit'
    end
  end

  private

  def user_params(_params)
    params = _params
    params.permit(:email, :password, :password_confirmation, :first_name, :last_name,:invitation_token, :provider, :uid, :remember_me)
  end

end