module Billing
  class Payment < ActiveRecord::Base
    belongs_to :account, inverse_of: :payments
    monetize :value_cents
  end
end
