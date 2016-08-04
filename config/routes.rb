Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :bucketlists, controller: :bucket_lists, except: [:new, :edit] do
        resources :items, except: [:new, :edit]
      end
  
      post "/auth/login" => "authentication#login"
      get "/auth/logout" => "authentication#logout"
    end
  end
end
