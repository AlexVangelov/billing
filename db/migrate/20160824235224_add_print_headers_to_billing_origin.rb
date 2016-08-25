class AddPrintHeadersToBillingOrigin < ActiveRecord::Migration
  def change
    add_column :billing_origins, :print_header, :string
    add_column :billing_origins, :print_footer, :string
  end
end
