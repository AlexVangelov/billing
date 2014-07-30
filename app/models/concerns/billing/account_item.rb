module Billing
  module AccountItem
    extend ActiveSupport::Concern
    
    included do
      acts_as_paranoid if respond_to?(:acts_as_paranoid)
      has_paper_trail class_name: 'Billing::Version' if respond_to?(:has_paper_trail)
      
      delegate :save, to: :account, prefix: :account
      delegate :origins, :payment_types, to: :account
      
      after_save :account_save
      
      validates_presence_of :account
    end

  end
end