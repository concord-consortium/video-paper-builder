class UsersController < ApplicationController
  before_filter :authenticate_admin! 
  
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to(admins_path,:notice=>"User: #{@user.name} was removed.")    
  end
end