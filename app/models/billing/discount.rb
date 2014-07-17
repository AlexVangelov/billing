module Billing
  class Discount < ActiveRecord::Base
    belongs_to :account, inverse_of: :discounts
  end
end
