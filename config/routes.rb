Rails.application.routes.draw do
  def shared_routes
    resources :bucketlists, controller: :bucket_lists, except: [:new, :edit] do
      resources :items, except: [:new, :edit]
    end

    scope "/auth", controller: :authentication do
      post "/create_user" => :create
      post "/login" => :login
      get "/logout" => :logout
    end

    get "/" => "authentication#welcome"
  end

  namespace :api, defaults: { format: "json" } do
    namespace :v1 do
      shared_routes
    end
  end

  namespace :api, defaults: { format: "json" } do
    namespace :v2 do
      shared_routes
    end
  end

  get "/" => redirect("/docs/index.html")
  match "*url" => "errors#invalid_route", via: :all
end
