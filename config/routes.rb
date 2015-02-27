Rails.application.routes.draw do
  ResqueWeb::Engine.eager_load!

  require 'resque_web'
  resque_web_constraint = lambda { |request| request.remote_ip == '127.0.0.1' }
  constraints resque_web_constraint do
    mount ResqueWeb::Engine => "/resque_web"
  end

  captcha_route
  get 'mobile/map'
  get 'mobile/hot_place'
  get 'mobile/setting'
  post 'feedback' => "mobile#feedback"

  get 'vendor' => "vendor#index"
  get 'vendor/index'
  get 'vendor/login'
  post 'vendor/login'
  get 'vendor/mine'
  get 'vendor/lottery'
  post 'vendor/send_sms_code'
  post 'vendor/create_park_statuses'
  delete 'vendor_logout' => "vendor#logout"

  resource :entrypoint, :controller => :entrypoint, :only => [:show]

  get '/auth/:provider/callback', to: 'vendor#login_from_wechat'

  namespace :api do
    resource :wechat, controller: :wechat, only: [:show, :create]
    resources :parks
  end

  namespace :vendor_api do
    resource :wechat, controller: :wechat, only: [:show, :create]
  end

  namespace :dashboard do
    get "/" => "base#index"

    resources :intros  do
      get 'preview'
    end
  end

  # staff only actions
  namespace :staff do
    get "/" => "base#index"
    get "login" => "session#login"
    post "login" => "session#login"
    delete "logout" => "session#destroy"
    resources :imports do
      put :merge
      resources :park_imports
    end

    resources :vendors
    resources :lotteries

    resources :lb_settings

    resources :users_parks
    resources :parks
    resources :wechat_users, :only => [:index] do
      resources :wechat_user_activities, :only => [:index]
    end
    resources :staffs do
      collection do
        get :i_want_change_pass
        patch :change_password
      end
    end
  end



  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'mobile#map'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
