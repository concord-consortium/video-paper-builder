# this overrides the registrations controller to block the ability for users
# to signup by themselves
class RegistrationsController < Devise::RegistrationsController
  def new
    flash[:info] = 'You must be invited to use Video Paper Builder'
    redirect_to root_path
  end

  def create
    flash[:info] = 'You must be invited to use Video Paper Builder'
    redirect_to root_path
  end
end