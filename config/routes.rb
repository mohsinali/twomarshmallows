Rails.application.routes.draw do
  get '/page-2', to: 'page2#index', as: 'page2'
  root 'home#index'
  match "/delayed_job" => DelayedJobWeb, :anchor => false, :via => [:get, :post]
  mount RedisBrowser::Web => '/redis-browser'

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    passwords: 'users/passwords'
  }

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

      resources :teacher_profiles, only: [:update]
    
    end
  end

end
