module Billing
  class TaxGroup < ActiveRecord::Base
    has_many :tax_group_fiscal_driver_mappings, inverse_of: :tax_group
  end
end
