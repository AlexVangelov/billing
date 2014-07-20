module Billing
  class PaymentType < ActiveRecord::Base
    has_many :payments
    validates_presence_of :name
  end
end
