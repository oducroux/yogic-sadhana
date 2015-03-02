Rails.application.routes.draw do


  # mount_devise_token_auth_for 'User', at: 'auth'

  mount_devise_token_auth_for 'User', at: 'auth', controllers: {
    confirmations:      'devise_token_auth/confirmations',
    passwords:          'devise_token_auth/passwords',
    omniauth_callbacks: 'devise_token_auth/omniauth_callbacks',
    registrations:      'devise_token_auth/registrations',
    sessions:           'token_auth/sessions',
    token_validations:  'devise_token_auth/token_validations'
  }

  scope "(:locale)", :locale => /en|fr/ do

    root to: "home#index"
    post "create_subscription" => "home#create_subscription", controller: "frontend/main"
    get "show_subscription_modal" => "home#show_subscription_modal", controller: "frontend/main"

    devise_for :admins, :controllers => { :sessions => 'authentication/sessions', :passwords => 'authentication/passwords', :registrations => 'authentication/registrations' }

    namespace :backend do
      resources :courses, shallow: true do
        resources :chapters, shallow: true do
          resources :practices, shallow: true do
            resources :medias
          end
          resources :theories, shallow: true do
            resources :medias
          end
        end
      end
    end

    # namespace :frontend do
    #   get "/ys" => "main#index", :as => "main_index"
    # end

    resources :ys, controller: 'frontend/main', only: [:index]

    namespace :api do
      namespace :v1 do
        resources :courses, only: [:index, :show] do
          get :menu
        end
        resources :chapters, only: [:index, :show]
        resources :practices, only: [:index, :show]
        resources :theories, only: [:index, :show]
        resources :medias, only: [:index, :show]
      end
      namespace :v2 do
        resources :courses, only: [:index, :show] do
          get :menu
        end
        resources :chapters, only: [:index, :show]
        resources :practices, only: [:index, :show]
        resources :theories, only: [:index, :show]
        resources :medias, only: [:index, :show]
      end
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
