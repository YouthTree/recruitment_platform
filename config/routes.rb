RecruitmentPlatform::Application.routes.draw do
  
  devise_for :users

  namespace :admin do
    root :to => 'dashboard#index'
    resources :teams
    resources :positions
    resources :questions
  end
  
  resources :positions, :only => [:show, :index]

  root :to => 'positions#index'
  get 'positions/:id', :to => 'positions#show', :as => :position

  # root :to => 'site#index'
  
end
