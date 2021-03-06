Rails.application.routes.draw do
  resources :albums,param: :name
  devise_for :users
  resources :users, only: [:show]
  resources :images
  resources :users, param: :email
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'
      post 'images/add-album'=> 'images#add_to_album'
      post 'users/request-friend'=> 'users#request_friend'
      post 'users/accept-friend'=> 'users#accept_friend'
      post 'users/remove-friend'=> 'users#remove_friend'
      get 'albums/:name/edit-images' => 'albums#change_images'
      get 'albums/:name/add-images' => 'albums#add_images'
      post 'images/remove-album' => 'images#remove_album'
      post 'images/temp-pic'=>'images#temp_pic'
      get 'user/change-email'=>'users#change_email'
      get 'user/friends'=>'users#show_friends'

      get 'search' => 'users#search'

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
