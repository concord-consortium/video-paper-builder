# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  protected

  # this is used so only admins can send invites
  def authenticate_inviter!
    authenticate_admin!(:force => true)
  end

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

  def dom_friend(args)
    id = args[:id]
    id.downcase.gsub(' ', '_')
  end
  
end
