VPB::Application.routes.draw do
  resources :wysihat_files

  match 'admin_console' => 'admins#index'
  match 'admin_accept_user_invitation' => 'admins#accept_user_invitation'
  match 'my_video_papers' => 'video_papers#my_video_papers'
  match 'my_shared_video_papers' => 'video_papers#shared_video_papers', :as => :shared_video_papers
  match 'test_exception' => 'home#test_exception'

  if Rails.env.test?
    # check if the name of this is login_for_test???
    match 'login_for_test/:id' => 'users#login_for_test'
  end

  match 'video_papers/report' => 'video_papers#report'
  match 'video_papers/user/:user' => 'video_papers#index', :as => :user_video_papers
  resources :video_papers do
    member do
      get 'share'
      put 'shared'
      get 'unshare'
      get 'edit_section'
      put 'update_section'
      get 'edit_section_duration'
      put 'update_section_duration'
      get 'publish'
      get 'unpublish'
      get 'transcoding_status'
    end
    resources :videos
  end

  devise_for :users, :controllers => { :registrations => "registrations", :omniauth_callbacks => "authentications" }
  devise_for :admins, :controllers => { :registrations => "registrations" }
  root :to => 'home#index'
  resources :admins
  resources :users

  get 'about/' => 'home#about', :as => :about
  get 'about/index' => 'home#about', :as => :about

  get 'contact/' => 'home#contact', :as => :contact
  get 'contact/index' => 'home#contact', :as => :contact

  get 'help_videos/:video_name' => 'home#help_videos', :as => :help_video

  post 'sns/transcoder_update' => 'sns#transcoder_update'

  get 'preflight' => 'home#preflight'

  #map.connect ':controller/:action/:id'
  #map.connect ':controller/:action/:id.:format'
end
