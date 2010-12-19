RecruitmentPlatform::Application.routes.draw do
  
  devise_for :users

  namespace :admin do
    root :to => 'dashboard#index'
    resources :teams
    resources :positions
    resources :questions
  end
  
  root :to => 'site#index'
  
end
