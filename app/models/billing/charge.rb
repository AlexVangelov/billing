module Billing
  class Charge < ActiveRecord::Base
    belongs_to :account, inverse_of: :charges
    monetize :price_cents
  end
end
