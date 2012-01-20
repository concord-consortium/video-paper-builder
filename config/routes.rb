ActionController::Routing::Routes.draw do |map|
  map.resources :wysihat_files

  map.admin_console '/admin_console', :controller=>'admins',:action=>"index"
  map.admin_accept_user_invitation '/admin_accept_user_invitation', :controller=>'admins', :action=>"accept_user_invitation"
  map.my_video_papers '/my_video_papers', :controller=>'video_papers',:action=>'my_video_papers'
  map.shared_video_papers '/my_shared_video_papers', :controller=>'video_papers',:action=>'shared_video_papers'

  if Rails.env=="cucumber"
    map.login_for_test '/login_for_test/:id', :controller=>'users',:action=>'login_for_test'
  end

  map.resources :video_papers, :member=> { 
      :share => :get,
      :shared=>:put,:unshare=>:get, 
      :edit_section => :get, 
      :update_section => :put,
      :edit_section_duration => :get,
      :update_section_duration => :put,
      :publish => :get,
      :unpublish =>:get
    } do |video_paper|
    video_paper.resources :videos
  end

  map.devise_for :users
  map.devise_for :admins
  map.root :controller => "home"
  map.resources :admins
  map.resources :users

  #map.connect ':controller/:action/:id'
  #map.connect ':controller/:action/:id.:format'
end
