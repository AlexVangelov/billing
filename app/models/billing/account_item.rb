module Billing
  module AccountItem
    extend ActiveSupport::Concern
    
    included do
      #belongs_to :account

      delegate :save, to: :account, prefix: :account
      after_save :account_save
      
      validates_presence_of :account
    end

  end
end