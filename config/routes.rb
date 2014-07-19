Billing::Engine.routes.draw do
  resources :accounts do
    resources :charges
    resources :discounts
    resources :payments
  end
  root "application#index"
end
