module Billing
  class Origin < ActiveRecord::Base
    has_many :bills, inverse_of: :origin
    has_many :charges, inverse_of: :origin
    has_many :payments, through: :bills
    if defined? Extface
      belongs_to :fiscal_device, ->(o) { where( extfaceable_id: o.master_id ) }, class_name: 'Extface::Device'
      belongs_to :transfer_device, ->(o) { where( extfaceable_id: o.master_id ) }, class_name: 'Extface::Device'
      belongs_to :print_device, ->(o) { where( extfaceable_id: o.master_id ) }, class_name: 'Extface::Device'
    end
    belongs_to :receipt_config, inverse_of: :origins

    validates_presence_of :name
    validates :payment_model, inclusion: { in: Payment::PAYMENT_MODELS }
    
    def external_payment?
      payment_model != Payment::PAYMENT_WITH_TYPE
    end
    
    def room_transfer?
      payment_model == Payment::ROOM_TRANSFER
    end
  end
end
