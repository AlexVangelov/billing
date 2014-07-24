module Billing
  module AccountItem
    extend ActiveSupport::Concern
    
    included do

      delegate :save, to: :account, prefix: :account
      delegate :origins, :payment_types, to: :account
      
      after_save :account_save
      
      validates_presence_of :account
    end

  end
end