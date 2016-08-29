module Billing
  class ReceiptConfig < ActiveRecord::Base
    has_many :origins, inverse_of: :receipt_config
  end
end
