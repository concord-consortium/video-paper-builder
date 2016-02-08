class HomeController < ApplicationController
  def index

    @user = User.new

    # if schoology is enabled then check for the realm parameters it sends to start the oauth process if needed
    session.delete :schoology_host
    session.delete :schoology_realm
    session.delete :schoology_realm_id
    if schoology_oauth_required?
      if request.referer && (host = URI(request.referer).host) && host !~ /concord\.org$/
        session[:schoology_host] = host
      end
      # check if the course or group realm is allowed
      if params[:realm] && params[:realm_id] && !SchoologyRealm.allowed?(params[:realm], params[:realm_id])
        render :partial => 'unauthorized_schoology_realm'
        return
      end
      session[:schoology_realm] = params[:realm]
      session[:schoology_realm_id] = params[:realm_id]
      redirect_to "/users/auth/schoology"
      return
    end

    if current_user
      # make sure any flashes that got set on the way here are
      # persisted
      flash.keep
      redirect_to new_video_paper_path
    end
  end

  def test_exception
    raise 'This is a test. This is only a test.'
  end

  def about
    @full_width_page = true
  end

  def contact
    @full_width_page = true
  end

  def help_videos
    video_name = params[:video_name]
    # remove slashes to prevent someone from trying to hack into other tempates
    video_name.gsub('/','')
    render "help_videos/#{video_name}", :layout => "help_videos"
  end

  def schoology_oauth_required?
    # no oauth if no schoology oauth environment variables set or the schoology realm params are not found
    return false unless ENV['SCHOOLOGY_CONSUMER_KEY'] && ENV['SCHOOLOGY_CONSUMER_SECRET'] && params[:realm] && params[:realm_id]

    # oauth required for any non-matching current users
    return !current_user || (current_user != (User.find_by_provider_and_uid('schoology', params[:realm_id]) rescue nil))
  end
end
