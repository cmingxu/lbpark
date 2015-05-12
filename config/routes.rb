Rails.application.routes.draw do
  ResqueWeb::Engine.eager_load!

  require 'resque_web'
  resque_web_constraint = lambda { |request| request.remote_ip == '127.0.0.1' }
  constraints resque_web_constraint do
    mount ResqueWeb::Engine => "/resque_web"
  end

  resources :pages,  :only => [:show] do end

  captcha_route
  # wechat requests
  get 'mobile/map'
  get 'map' => "mobile/map"
  get 'mobile/hot_place'
  get 'mobile/setting'
  get 'mobile/feedback'
  get 'mobile/js_log'

  get 'heatmap' => "welcome#heatmap"

  post 'feedback' => "mobile#feedback"

  get 'vendor' => "vendor#index"
  get 'vendor/index'
  get 'vendor/bind_mobile'
  post 'vendor/bind_mobile'
  get 'vendor/mine'
  get 'vendor/lottery'
  post 'send_sms_code' => "api/base#send_sms_code"
  post 'vendor/create_park_statuses'
  get 'vendor/coupons'
  get 'vendor/high_score_list'
  get 'vendor/high_score'

  get '/auth/wechat_vendor/callback', to: 'vendor#login_from_wechat'
  get '/auth/wechat_user/callback', to: 'mobile#login_from_wechat'
  get 'auth/failure', to: 'vendor#failure'

  resources :mobile_coupons, :only => [:index, :show] do
    collection do
      post "claim/pay" => "mobile_coupons#claim"
      get :coupons_nearby
      get :coupons_owned
      get :rule
      get :bind_mobile
      post :bind_mobile
      post :notify
    end

    member do
      get :show_order
      get :coupon_show
      get :check_if_coupon_used
    end
  end

  resources :vendor_coupons, :only => [:index] do
    member do
      get :use
    end
  end

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

  namespace :client do
    get "/" => "base#index"
    get "login" => "session#login"
    post "login" => "session#login"
    delete "logout" => "session#destroy"

    resources :coupons
    resources :park_maps do
      resources :park_spaces do
        member do
          patch :rename
          patch :change_usage_status
          patch :change_vacancy_status
        end
      end
    end
    resources :parks do
      resources :park_maps
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

    resources :qr_codes do
      member do
        get :download
      end
    end
    resources :pages
    resources :clients

    resources :vendors do
      patch :switch_scan_coupon_status
      collection do

        get :rentention
        get :by_hour
        get :by_day
        get :by_vendor
      end
    end
    resources :lotteries do
      collection do
        post :open
      end
    end

    resources :lb_settings

    resources :park_statuses
    resources :users_parks
    resources :parks do
      resources :clients
      resources :park_maps do
        collection do
          patch :rename
        end
      end
    end
    resources :wechat_users, :only => [:index] do
      resources :wechat_user_activities, :only => [:index]
    end

    resources :coupon_tpls do 
      resources :coupons
      member do
        patch :publish
        patch :stop
        patch :highlight
        patch :dehighlight
        post :create_park_notice_item
        delete :delete_park_notice_item
      end
    end
    resources :coupons do
      resources :coupon_logs
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
