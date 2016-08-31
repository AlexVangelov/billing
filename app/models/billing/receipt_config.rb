module Billing
  class ReceiptConfig < ActiveRecord::Base
    has_many :origins, inverse_of: :receipt_config, dependent: :restrict_with_exception
    validates :name, presence: true, uniqueness: { scope: :master_id }
  end
end
