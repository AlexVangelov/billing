module ActionDispatch::Routing
  class Mapper
    def billing_for(resource, options = {})
      mapping = Billing.add_mapping(resource, options)
      mount Billing::Engine, at: mapping.mount_point, as: [options[:as],:billing].compact.join('_')
      get "#{mapping.mount_point}/accounts", to: "billing/accounts#index", as: options[:as] ? options[:as].to_s.pluralize.intern : :billing_accounts
      get "#{mapping.mount_point}/accounts/:account_id", to: "billing/accounts#show", as: options[:as] ? options[:as].to_s.singularize.intern : :billing_account
      get "#{mapping.mount_point}/accounts/:account_id/charges", to: "billing/charges#index", as: options[:as] ? "#{options[:as].to_s.singularize.intern}_charges" : :billing_account_charges
      get "#{mapping.mount_point}/accounts/:account_id/charges/new", to: "billing/charges#new", as: options[:as] ? "#{options[:as].to_s.singularize.intern}_new_charge" : :billing_account_new_charge
      get "#{mapping.mount_point}/accounts/:account_id/charges/:charge_id", to: "billing/charges#show", as: options[:as] ? "#{options[:as].to_s.singularize.intern}_charge" : :billing_account_charge
      get "#{mapping.mount_point}/accounts/:account_id/payments", to: "billing/payments#index", as: options[:as] ? "#{options[:as].to_s.singularize.intern}_payments" : :billing_account_payments
      get "#{mapping.mount_point}/accounts/:account_id/payments/new", to: "billing/payments#new", as: options[:as] ? "#{options[:as].to_s.singularize.intern}_new_payment" : :billing_account_new_payment
      get "#{mapping.mount_point}/accounts/:account_id/payments/:payment_id", to: "billing/payments#show", as: options[:as] ? "#{options[:as].to_s.singularize.intern}_payment" : :billing_account_payment
    end
  end
end