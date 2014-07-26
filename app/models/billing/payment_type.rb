module Billing
  class PaymentType < ActiveRecord::Base
    has_many :payments, inverse_of: :payment_type
    has_many :payment_type_fiscal_driver_mappings, inverse_of: :payment_type

    validates_presence_of :name
  end
end
