class AdminsController < ApplicationController
  before_filter :authenticate_admin! 
  def index
    @admins = Admin.all
    @users = User.all
  end
end
