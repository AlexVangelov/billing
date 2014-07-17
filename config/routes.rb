Billing::Engine.routes.draw do
  namespace :billing do
  get 'payments/new'
  end

  namespace :billing do
  get 'discounts/new'
  end

  resources :accounts do
    resources :charges
    resources :discounts
    resources :payments
  end
end
