RecruitmentPlatform::Application.routes.draw do
  
  namespace :admin do
    root :to => 'dashboard#index'
    resources :teams
    resources :positions
    resources :questions
  end
  
  root :to => 'site#index'
  
end
