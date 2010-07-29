# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  protected
  def authenticate_resource!
    authenticate_admin!
  end
  
  def authenticate_any_user!
    if user_signed_in?
      current_user
    elsif admin_signed_in?
      current_admin
    else
      authenticate_user!
    end
  end
  
end
