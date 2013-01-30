VPB::Application.routes.draw do
  resources :wysihat_files

  match 'admin_console' => 'admins#index'
  match 'admin_accept_user_invitation' => 'admins#accept_user_invitation'
  match 'my_video_papers' => 'video_papers#my_video_papers'
  match 'shared_video_papers' => 'video_papers#shared_video_papers'
  match 'test_exception' => 'home#test_exception'

  if Rails.env=="cucumber"
    # check if the name of this is login_for_test???
    match 'login_for_test/:id' => 'users#login_for_test'
  end

  match 'video_papers/report' => 'video_papers#report'
  resources :video_papers do
    member do
      get 'share'
      get 'unshare'
      get 'edit_section'
      put 'update_section'
      get 'edit_section_duration'
      put 'update_section_duration'
      get 'publish'
      get 'unpublish'
    end
    resources :videos
  end

  devise_for :users
  devise_for :admins
  root :to => 'home#index'
  resources :admins
  resources :users

  #map.connect ':controller/:action/:id'
  #map.connect ':controller/:action/:id.:format'
end
