Rails.application.routes.draw do
  namespace :admin do
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

    end

    devise_for :users, as: :admin, path: 'admin', controllers: {
      sessions: 'admin/users/sessions'
    }, skip: [:registrations]
  end

  constraints(ClientDomainConstraint.new) do
    namespace :client do
      root "home#index"
      get 'me', to: 'me#index', as: 'me'
      resources :address
      resources 'client/lottery', as: 'lottery', path: 'lottery', only: :index
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
