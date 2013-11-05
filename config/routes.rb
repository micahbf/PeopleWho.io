BillTracker::Application.routes.draw do
  get "bills/new"

  get "bills/create"

  get "bills/edit"

  get "bills/update"

  get "bills/destroy"

  get "bills/index"

  get "bills/show"

  resources :users, only: [:new, :create]
  resource :session, only: [:new, :create, :destroy]
end
