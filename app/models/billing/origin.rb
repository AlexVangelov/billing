module Billing
  class Origin < ActiveRecord::Base
    has_many :accounts, inverse_of: :origin
    has_many :charges, inverse_of: :origin
    has_many :payments, through: :accounts
    if defined? Extface
      belongs_to :fiscal_device, ->(o) { where( extfaceable_id: o.master_id ) }, class_name: 'Extface::Device'
    end

    validates_presence_of :name
    validates :payment_model, inclusion: { in: Payment::PAYMENT_MODELS }
    
    def external_payment?
      payment_model != Payment::PAYMENT_WITH_TYPE
    end
  end
end
