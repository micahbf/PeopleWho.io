BillTracker::Application.routes.draw do
  resources :users, only: [:new, :create, :show] do
    member do
      post :settle
    end
  end
  resource :session, only: [:new, :create, :destroy]
  resources :bills, only: [:new, :create, :index, :show]
end
