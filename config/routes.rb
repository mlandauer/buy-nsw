Rails.application.routes.draw do

  devise_for :users,  path: '',
                      path_names: {
                        sign_in: 'sign-in',
                      },
                      controllers: {
                        registrations: 'users/registrations',
                        confirmations: 'users/confirmations',
                      },
                      skip: [
                        :registrations,
                      ],
                      skip_helpers: true

  devise_scope :user do
    get '/register', to: redirect('/sign-in'), as: :register_without_type
    get '/register/:type', to: 'users/registrations#new', as: :registration
    post '/register/:type', to: 'users/registrations#create'
    get '/register/:type/confirm', to: 'users/registrations#confirm', as: :registration_confirm

    get '/account', to: 'users/registrations#edit', as: :edit_account
    put '/account', to: 'users/registrations#update', as: :account
  end

  namespace :sellers do
    resources :applications, only: [:new, :create, :show, :update], controller: 'applications/root' do
      member do
        get :submit
        post :submit, to: 'applications/root#do_submit'
      end

      resources :products, controller: 'applications/products' do
        member do
          post :clone
        end
      end
      get '/products/:id/:step', to: 'applications/products#edit', as: :product_step
      patch '/products/:id/:step', to: 'applications/products#update'

      resources :invitations, controller: 'applications/invitations', only: [:index, :new, :create] do
        collection do
          get :accept
          patch '/accept', to: 'applications/invitations#update_accept', as: :update_accept
        end
      end
    end
    get '/applications/:id/:step', to: 'applications/steps#show', as: :application_step
    patch '/applications/:id/:step', to: 'applications/steps#update'

    resources :profiles, only: :show
    resources :waitlist_invitations, path: 'waitlist', only: :show do
      patch :accept, on: :member
    end

    get '/search', to: 'search#search', as: :search
    get '/dashboard', to: 'dashboard#show', as: :dashboard
  end

  namespace :buyers do
    resources :applications do
      member do
        get :review
        post :submit
      end
    end
    get '/applications/:id/manager-approve', to: 'applications#manager_approve', as: :manager_approve_application
    get '/applications/:id/:step', to: 'applications#show', as: :application_step

    get '/dashboard', to: 'dashboard#show', as: :dashboard
    scope 'products/:id' do
      resources :product_orders, only: [:new, :create], path: 'orders'
    end
  end

  get '/cloud', to: 'static#cloud', as: :cloud
  get '/cloud/:section', to: 'pathways/search#search', as: :pathway_search
  get '/cloud/:section/products/:id', to: 'pathways/products#show', as: :pathway_product

  namespace :admin, path: 'ops' do
    resources :buyer_applications, path: 'buyer-applications' do
      member do
        get :buyer_details

        patch :assign
        patch :decide
        post :notes
        post :deactivate
      end
    end

    resources :sellers, only: [:index]

    resources :seller_applications, path: 'seller-applications', controller: 'seller_versions' do
      member do
        get :seller_details
        get :documents

        patch :assign
        patch :decide
        post :notes
        post :revert
      end

      resources :products, only: :show, controller: 'seller_versions/products'
    end

    resources :waiting_sellers, path: 'waiting-sellers' do
      collection do
        post :upload, to: 'waiting_sellers#upload'
        get :invite, to: 'waiting_sellers#invite'
        post :invite, to: 'waiting_sellers#do_invite'
      end
    end

    resources :users, only: [:index] do
      post :impersonate, on: :member
      post :stop_impersonating, on: :collection
    end

    resources :problem_reports, path: 'problem-reports', only: [:index, :show] do
      member do
        post :resolve
        put :tag
      end
    end

    resources :product_orders, only: :index, path: 'product-orders'

    root to: 'root#index'
  end

  namespace :feedback do
    resources :problem_reports, path: 'problem-reports', only: [:new, :create]
  end

  get '/performance', to: 'performance#index'

  get '/contact', to: 'static#contact'
  get '/join-mailing-list', to: 'static#join_mailing_list'
  get '/privacy', to: 'static#privacy'
  get '/terms-of-use', to: 'static#terms_of_use'
  get '/accessibility', to: 'static#accessibility'
  get '/core-terms', to: redirect('https://www.procurepoint.nsw.gov.au/before-you-buy/standard-procurement-contract-templates/it-contract-templates/procure-it-framework-0')
  get '/guides/seller', to: 'static#seller_guide'
  get '/guides/buyer', to: 'static#buyer_guide'
  get '/license', to: 'static#license'
  # Health check page for load balancer - never use basic auth
  get '/health', to: 'static#health'
  get '/govdc', to: 'static#govdc'

  match '/404', to: 'errors#not_found', via: :all
  match '/500', to: 'errors#internal_server_error', via: :all

  root to: redirect('/cloud')
end
