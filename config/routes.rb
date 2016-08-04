Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post "/auth/login" => "authentication#login"
      get "/auth/logout" => "authentication#logout"
    end
  end
end
