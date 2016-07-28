Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      root "home#index"

      get "users/index"
      post "auth_user" => "authentication#authenticate_user"
    end
  end
end
