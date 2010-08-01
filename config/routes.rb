ActionController::Routing::Routes.draw do |map|
  map.resources :video_papers do |video_paper|
    video_paper.resources :videos
  end

  map.devise_for :users
  map.devise_for :admins
  map.root :controller => "home"

  #map.connect ':controller/:action/:id'
  #map.connect ':controller/:action/:id.:format'
end
