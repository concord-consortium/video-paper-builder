module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /the home\s?page/
      '/'
    #ADMINS
    when /the admin sign in page/
      '/admins/sign_in'
    when /the admin sign up page/
      '/admins/sign_up'
    when /the admin invitation page/
      '/admins/invitation/new'
    when /the (.*)'s admin confirmation page/
      '/admins/confirmation?confirmation_token=' + Admin.find_by_email($1).confirmation_token.to_s
    when /the admin sign out page/
      '/admins/sign_out'
    when /the admin console/
      '/admin_console'
    #USERS
    when /the user sign in page/
      '/users/sign_in'
    when /the user sign up page/
      '/users/sign_up'
    when /the user invitation page/
      '/users/invitation/new'
    when /the (.*)'s user confirmation page/
      '/users/confirmation?confirmation_token=' + User.find_by_email($1).confirmation_token.to_s
    when /the (.*)'s user invitation page/
      # regenerate an invitation to get the raw token as it is not saved in the database
      user = User.find_by_email($1)
      user.deliver_invitation
      original_token = user.raw_invitation_token.to_s
      '/users/invitation/accept?invitation_token=' + original_token
    #VIDEO PAPERS
    when /my video papers page/
      '/my_video_papers'
    when /my shared papers page/
      '/my_shared_video_papers'
    when /the video paper page/
      '/video_papers'
    when /the new video paper page/
      '/video_papers/new'
    when /(.*)'s video paper edit page/
      '/video_papers/' + VideoPaper.find_by_title($1).id.to_s + '/edit'
    when /(.*)'s video paper page/
      '/video_papers/' + VideoPaper.find_by_title($1).id.to_s
    when /(.*)'s sharing page/
      '/video_papers/' + VideoPaper.find_by_title($1).id.to_s + '/share'
    when /(.*)'s shared page/
      '/video_papers/' + VideoPaper.find_by_title($1).id.to_s + '/shared'
    #VIDEOS
    when /the (.*)'s edit video page/
      vp = VideoPaper.find_by_title($1)
      '/video_papers/' + vp.id.to_s + '/videos/' + vp.video.id.to_s + '/edit'
    when /the (.*)'s new video page/
      '/video_papers/' + VideoPaper.find_by_title($1).id.to_s + '/videos/new'
    #VIDEO PAPER SECTIONS
    when /edit titleless section on (.*)/
      '/video_papers/' + VideoPaper.find_by_title($1).id.to_s + '/edit_section'
    when /(.*)'s video paper (.*) section/
      '/video_papers/' + VideoPaper.find_by_title($1).id.to_s + '/#' + ($2)
    when /(.*)'s video paper edit timing page/
      '/video_papers/' + VideoPaper.find_by_title($1).id.to_s + '/edit_section_duration'

    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      begin
        page_name =~ /the (.*) page/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue Object => e
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
