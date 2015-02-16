module Billing
  module BillItem
    extend ActiveSupport::Concern
    
    included do
      acts_as_paranoid if respond_to?(:acts_as_paranoid)
      has_paper_trail class_name: 'Billing::Version' if respond_to?(:has_paper_trail)
      
      delegate :save, to: :bill, prefix: :bill
      delegate :origins, :payment_types, :tax_groups, to: :bill
      
      after_save :bill_save
      after_destroy :bill_save
    end

  end
end