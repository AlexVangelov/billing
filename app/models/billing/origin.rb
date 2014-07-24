module Billing
  class Origin < ActiveRecord::Base
    has_many :accounts
    
    validates_presence_of :name, :payment_model
  end
end
