class Profile < ActiveRecord::Base
  has_billing payment_types: Billing::PaymentType.all
end
