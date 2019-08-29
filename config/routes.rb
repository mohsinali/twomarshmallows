Rails.application.routes.draw do
  get '/page-2', to: 'page2#index', as: 'page2'
  root 'home#index'
  match "/delayed_job" => DelayedJobWeb, :anchor => false, :via => [:get, :post]
  mount RedisBrowser::Web => '/redis-browser'

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    passwords: 'users/passwords'
  }

  resources :agents
  resources :notes
  resources :emails, only: [:create]
  resources :meetings, only: [:create]
  resources :settings, only: [:index] do
    collection do
      post :update_user_field
      get :reset_google_token
    end
  end
  resources :auth, only: [:index, :create] do
    collection do
      get "/:provider/callback" => 'auth#create'
    end
  end
  resources :tasks do
    collection do
      post :update_status
    end
  end
  resources :contacts, only: [:index, :show] do
    collection do
      post :assign_agent
      get '/sidebox_detail/:id', to: 'contacts#sidebox_detail'
    end
  end

  namespace :api do
    namespace :v1 do

      resources :users, only: [:show] do
        collection do
          post :signin
          post :signup
          get  :address, to: 'users#address'
          post :forgotpassword
          post :resetpassword
          post :update_password
        end
      end

      resources :profile do
        collection do
          get 'profile/:id', to: 'profile#show'
        end
      end

    end
  end

end
