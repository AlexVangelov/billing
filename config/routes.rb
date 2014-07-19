Billing::Engine.routes.draw do
  resources :accounts do
    resources :charges
    resources :modifiers
    resources :payments
  end
  root "application#index"
end
