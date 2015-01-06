Moovup::Application.routes.draw do
  mount Bootsy::Engine => '/bootsy', as: 'bootsy'
  root 'home#index'
  get 'index/pro', to: 'home#index_pro', as: 'pro_root'
  post '/', to: 'home#test'

  devise_for :users, :controllers => { registrations:  'users/registrations' }
  devise_scope :user do
    get '/favorites', to: 'users/registrations#favorites', as: 'user_favorites'
    get '/profil', to: 'users/registrations#profil', as: 'user_profil'
    get '/edit_avatar', to: 'users/registrations#edit_avatar', as: 'edit_avatar'
    put '/edit_avatar', to: 'users/registrations#update_avatar'

    get '/admin/offers', to: 'users/admin#offers', as: 'offers_admin'
    get '/admin/offer/:id', to: 'users/admin#valid_offer', as: 'valid_offer_admin'
    put '/admin/offer/:id', to: 'users/admin#offer_send_validation'

    get '/admin/shops', to: 'users/admin#shops', as: 'shops_admin'
    get '/admin/shop/:id', to: 'users/admin#valid_shop', as: 'valid_shop_admin'
    put '/admin/shop/:id', to: 'users/admin#shop_send_validation'
  end
  
  resources :shops, except: [:index]  do
    member do
      put 'like', to: "shops#liker"
      put 'submit', to: 'shops#submit'
    end
    collection do
      get "/index/:status", to: 'shops#index', as: "index"
      get "aroundme", to: "shops#show_near"
      post "aroundme", to: "shops#set_requested_coords"
    end
  end

  resources :offers, except: [:show, :index] do
    collection do
      get "/index/:status", to: 'offers#index', as: "index"
      get "aroundme/:category/:favorites", to: "offers#show_near", as: "aroundme"
      post "aroundme/:category/:favorites", to: "offers#set_requested_coords"
    end
    member do
      get 'publish', to: 'offers#publisher_selection'
      put 'publish', to: 'offers#publish'
      put 'submit', to: 'offers#submit'
      delete "publish/:shop_id", to: "offers#unpublish", as: "unpublish"
    end
  end
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
