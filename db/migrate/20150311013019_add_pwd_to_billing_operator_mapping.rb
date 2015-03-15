class AddPwdToBillingOperatorMapping < ActiveRecord::Migration
  def change
    add_column :billing_op_fp_mappings, :pwd, :string
  end
end
