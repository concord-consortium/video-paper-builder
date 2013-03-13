class UsersController < ApplicationController
  before_filter :authenticate_admin!, :except => [ :login_for_test]
  
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to(admins_path,:notice=>"User: #{@user.name} was removed.")    
  end

  # a speical action to speed up tests, the route for this is only enabled in cucumber environment
  def login_for_test
    user = User.find params[:id]
    sign_in(user)
    render :text => "OK"
  end

  def index
    respond_to do |format|
       format.csv { render :csv => User.limit(500)}
    end
  end
end