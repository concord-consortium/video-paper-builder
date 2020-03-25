VPB::Application.routes.draw do
  resources :wysihat_files

  get 'admin_console' => 'admins#index'
  get 'admin_accept_user_invitation' => 'admins#accept_user_invitation'
  patch 'admin_accept_user_invitation' => 'admins#accept_user_invitation'
  get 'my_video_papers' => 'video_papers#my_video_papers'
  get 'my_shared_video_papers' => 'video_papers#shared_video_papers', :as => :shared_video_papers
  get 'test_exception' => 'home#test_exception'

  if Rails.env.test?
    # check if the name of this is login_for_test???
    get 'login_for_test/:id' => 'users#login_for_test'
  end

  get 'video_papers/report' => 'video_papers#report'
  get 'video_papers/user/:user' => 'video_papers#index', :as => :user_video_papers
  resources :video_papers do
    member do
      get 'share'
      patch 'shared'
      get 'unshare'
      get 'edit_section'
      patch 'update_section'
      get 'edit_section_duration'
      patch 'update_section_duration'
      get 'publish'
      get 'unpublish'
      get 'transcoding_status'
    end
    resources :videos do
      member do
        post 'start_transcoding_job'
      end
    end
  end

  devise_for :users, :controllers => { :registrations => "registrations", :omniauth_callbacks => "authentications" }
  devise_for :admins, :controllers => { :registrations => "registrations" }
  root :to => 'home#index'
  resources :admins
  resources :users

  get 'about/' => 'home#about', :as => :about

  get 'contact/' => 'home#contact', :as => :contact

  get 'help_videos/:video_name' => 'home#help_videos', :as => :help_video

  post 'sns/transcoder_update' => 'sns#transcoder_update'

  get 'preflight' => 'home#preflight'

  #map.connect ':controller/:action/:id'
  #map.connect ':controller/:action/:id.:format'
end
