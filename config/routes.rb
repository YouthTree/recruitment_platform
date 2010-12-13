RecruitmentPlatform::Application.routes.draw do
  
  namespace :admin do
    root :to => 'dashboard#index'
  end
  
  root :to => 'site#index'
  
end
