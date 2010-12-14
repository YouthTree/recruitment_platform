RecruitmentPlatform::Application.routes.draw do
  
  namespace :admin do
    root :to => 'dashboard#index'
    resources :teams
  end
  
  root :to => 'site#index'
  
end
