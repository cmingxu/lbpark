Rails.application.routes.draw do

  namespace :staff do
  get 'staffs/index'
  end

  namespace :staff do
  get 'staffs/new'
  end

  namespace :staff do
  get 'staffs/edit'
  end

  captcha_route
  namespace :staff do
  get 'parks/index'
  end

  namespace :staff do
  get 'parks/new'
  end

  namespace :staff do
  get 'parks/edit'
  end

  get 'vendor/index'
  get 'vendor/login'
  get 'vendor/mine'
  get 'vendor/lottory'

  get 'mobile/map'
  get 'mobile/hot_place'

  namespace :api do
    resources :parks
    resources :park_statuses, :only => [:create]
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

    resources :parks
    resources :staffs
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
