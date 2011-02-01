RecruitmentPlatform::Application.routes.draw do
  
  devise_for :users

  namespace :admin do
    root :to => 'dashboard#index'
    resources :teams
    resources :positions do
      resources :position_applications, :path => 'applications', :only => [:show, :index] do
        member do
          get :printable
        end
      end
      member do
        get :clone_position, :path => 'clone'
      end
      collection do
        put :reorder
      end
    end
    resources :questions
    resources :contents
  end
  
  resources :positions, :only => [:show, :index] do
    member do
      get :applied
      get  :apply
      post :apply
    end
    resources :position_applications, :path => 'applications', :only => [:create, :edit, :update, :show] do
      member do
        get :applied
      end
    end
  end

  root :to => 'positions#index'
  get 'positions/:id', :to => 'positions#show', :as => :position

  # root :to => 'site#index'
  
end
