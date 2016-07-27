Rails.application.routes.draw do

  scope '/api' do
    mount_devise_token_auth_for 'Teacher', at: '/auth'
    # resources :groups, except: [:new, :edit]
    get     'teacher/get'                 => 'teacher#get'

    get     'teacher/profile-pic'         => 'teacher#chunks'
    get     'teacher/profile'             => 'teacher#profile'
    
    post    'teacher'                     => 'teacher#update'


    get      'subjects'                   => "subject#index"


    get      'search'                     => "search#search"
    get      'search-subjects'            => "search#search_subjects"
    resources :teacher, only: [ :update ] do
      get     'show-teacher'              => 'teacher#show_teacher'
      post    'add-subject'               => 'subject#add_subject'

      post    'pic'                       => "photos#create"
      delete  'remove-subject'            => 'subject#remove_subject'

      resources :experience,          only: [ :create, :destroy ]
      resources :qualification,       only: [ :create, :destroy ]
      resources :location,            only: [ :create, :destroy ]
      resources :conversation,        only: [ :create ]

    end
  end

  get 'oauth2/callback' => 'static#welcome'
  as :teacher do
    # Define routes for Teacher within this block.

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
  # resources :teachers, only: [:index, :create, :destroy], defaults: {format: :json}
  root to: 'static#index'
end
