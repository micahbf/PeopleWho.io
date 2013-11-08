BillTracker::Application.routes.draw do
  resources :users, only: [:new, :create, :show] do
    member do
      post :settle
    end
  end
  resource :session, only: [:new, :create, :destroy]
  resources :bills, only: [:new, :create, :index, :show]

  namespace :api do
    resources :users, only: [:show, :index]
    resources :bills, only: [:create, :show, :index]
  end

  root to: "static_pages#root"
end
