class AuthenticationsController < Devise::OmniauthCallbacksController
  def schoology
    omniauth = request.env["omniauth.auth"]
    begin
      @user = User.find_for_omniauth(omniauth, session[:schoology_realm], session[:schoology_realm_id])
      sign_in_and_redirect @user, :event => :authentication
    rescue Exception => e
      set_flash_message :alert, :failure, kind: "Schoology", reason: e.message
      redirect_to after_omniauth_failure_path_for(resource_name)
    end
  end
end
