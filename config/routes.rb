Rails.application.routes.draw do
  devise_for :users, as: :client, path: 'client', controllers: {
    sessions: 'client/users/sessions'
  }

  devise_for :users, as: :admin, path: 'admin', controllers: {
    sessions: 'admin/users/sessions'
  }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root 'welcome#index'

  namespace :admin do
    root "home#index"
  end

  namespace :client do
    root "home#index"
  end

end
