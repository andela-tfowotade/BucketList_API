Rails.application.routes.draw do
  namespace :api do
  namespace :v1 do
    get 'bucket_lists/index'
    end
  end

  namespace :api do
    namespace :v1 do
      root "home#index"

      resources :bucket_lists

      get "users/index"
      post "auth_user" => "authentication#authenticate_user"
    end
  end
end
