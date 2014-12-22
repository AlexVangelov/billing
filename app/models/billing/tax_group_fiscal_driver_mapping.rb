module Billing
  class TaxGroupFiscalDriverMapping < ActiveRecord::Base
    self.table_name = "billing_tg_fp_mappings"
    belongs_to :tax_group, inverse_of: :tax_group_fiscal_driver_mappings
    belongs_to :extface_driver, class_name: 'Extface::Driver'
  end
end
