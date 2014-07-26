module Billing
  class PaymentTypeFiscalDriverMapping < ActiveRecord::Base
    self.table_name = "billing_pt_fp_mappings"
    belongs_to :payment_type, inverse_of: :payment_type_fiscal_driver_mappings
    belongs_to :extface_driver, class_name: 'Extface::Driver'
  end
end
