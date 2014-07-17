module Billing
  class Account < ActiveRecord::Base
    has_many :charges, inverse_of: :account
    has_many :discounts, inverse_of: :account
    has_many :payments, inverse_of: :account
  end
end
