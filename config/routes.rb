Rails.application.routes.draw do

  root to: "login#index"

  resources :users do
    collection do
      get 'login'
    end
  end

  resources :login, only: [:index, :new, :create]

  resources :user_points, only: :index

  resources :weixin, only: [:index, :create]
end
