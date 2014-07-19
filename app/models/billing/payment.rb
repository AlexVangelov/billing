module Billing
  class Payment < ActiveRecord::Base
    include AccountItem
    belongs_to :account, inverse_of: :payments, validate: true
    monetize :value_cents
    
    validates_presence_of :value
  end
end
