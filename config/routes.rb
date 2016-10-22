Rails.application.routes.draw do

  match 'logger/rails_client_logger/log' => 'logger#log', via: :post
  mount RailsClientLogger::Engine, :at => "logger"
  scope '/api' do
    mount_devise_token_auth_for 'Teacher', at: 'auth', controllers: { passwords: 'devise/passwords', omniauth_callbacks: 'omniauth_callbacks' }
    # resources :groups, except: [:new, :edit]

    get     'teacher/profile-pic'         => 'teacher#chunks'
    get     'teacher/profile'             => 'teacher#profile'
    
    post    'teacher'                     => 'teacher#update'


    get      'subjects'                   => "subject#index"


    get      'search'                     => "search#search"
    get      'search-subjects'            => "search#search_subjects"
    resources :teacher, only: [ :index, :show, :update ] do
      get       'show-teacher'            => 'teacher#show_teacher'
      post      'add-subject'             => 'subject#add_subject'

      # post    'pic'                       => "photos#create"
      # delete  'delete-pic'                => "photos#destroy"
      delete    'remove-subject'          => 'subject#remove_subject'

      resources :experience,          only: [ :create, :destroy ], defaults: {format: :json}
      resources :qualification,       only: [ :create, :destroy ], defaults: {format: :json}
      resources :location,            only: [ :create, :destroy ], defaults: {format: :json} 
      post    'manual-address'            => 'location#manual_address'
      resources :photos,              only: [ :create, :destroy ], defaults: {format: :json}
      



    end
    
    resources :category,            only: [ :create, :update, :index, :destroy ]  do
      get     'category-subjects'     => 'category#category_subjects'
      resources :subject,             only: [ :create, :destroy ]
    end

    resources :conversation,        only: [ :create, :index ]
    resources :subject,             only: [ :index, :update ]
  end





  get 'oauth2/callback' => 'static#welcome'
  as :teacher do
    # Define routes for Teacher within this block.

  end
  
  root to: 'static#index'
  get '*path'           => 'static#index'
end
