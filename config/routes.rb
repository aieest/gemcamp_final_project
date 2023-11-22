Rails.application.routes.draw do
  namespace :admin do
    get 'offers/index'
    get 'tickets/index'
    get 'items/index'
  end
  namespace :client do
    get 'lottery/index'
    get 'invite/index'
  end
  constraints(AdminDomainConstraint.new) do
    namespace :admin do
      root "home#index"
      resources :items, except: :show do
        member do
          post 'start'
          post 'pause'
          post 'end'
          post 'cancel'
        end
      end
      resources :categories, except: :show
      resources :tickets, only: :index do
        member do
          post 'cancel'
        end
      end
      resources :winners, as: 'winners', path: 'winners', only: [:index, :update]
    end

    devise_for :users, as: :admin, path: 'admin', controllers: {
      sessions: 'admin/users/sessions'
    }, skip: [:registrations]
  end

  constraints(ClientDomainConstraint.new) do
    namespace :client do
      root "home#index"
      get 'me', to: 'me#index', as: 'me'
      resources :address do
        member do
          patch 'default'
        end
      end
      resources :lottery, only: [:index, :show]
      resources :tickets, as: 'submit_tickets', path: 'submit_tickets', only: [:create]
    end

    devise_for :users, as: :client, path: 'client', controllers: {
      sessions: 'client/users/sessions',
      registrations: 'client/users/registrations'
    }
  end

  namespace :api do
    namespace :v1 do
      resources :regions, only: [:index, :show], defaults: { format: :json } do
        resources :provinces, only: :index, defaults: { format: :json }
      end

      resources :provinces, only: [:index, :show], defaults: { format: :json } do
        resources :cities, only: :index, defaults: { format: :json }
      end

      resources :cities, only: [:index, :show], defaults: { format: :json } do
        resources :barangays, only: :index, defaults: { format: :json }
      end

      resources :barangays, only: [:index, :show], defaults: { format: :json }
    end
  end
end
