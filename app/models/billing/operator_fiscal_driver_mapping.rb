module Billing
  class OperatorFiscalDriverMapping < ActiveRecord::Base
    self.table_name = "billing_op_fp_mappings"
    belongs_to :operator, inverse_of: :operator_fiscal_driver_mappings
    belongs_to :extface_driver, class_name: 'Extface::Driver'
  end
end
