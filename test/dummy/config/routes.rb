Rails.application.routes.draw do
  resources :profiles do
    billing_for :profile
  end
end
