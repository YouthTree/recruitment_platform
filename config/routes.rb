RecruitmentPlatform::Application.routes.draw do
  
  devise_for :users

  namespace :admin do
    root :to => 'dashboard#index'
    resources :teams
    resources :positions
    resources :questions
  end
  
  resources :positions, :only => [:show, :index] do
    member do
      get  :apply
      post :apply
    end
  end

  root :to => 'positions#index'
  get 'positions/:id', :to => 'positions#show', :as => :position

  # root :to => 'site#index'
  
end
