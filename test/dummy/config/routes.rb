Rails.application.routes.draw do

  mount Billing::Engine => "/billing"
end
