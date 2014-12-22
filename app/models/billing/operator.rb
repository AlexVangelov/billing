module Billing
  class Operator < ActiveRecord::Base
    has_many :operator_fiscal_driver_mappings, inverse_of: :operator
  end
end
