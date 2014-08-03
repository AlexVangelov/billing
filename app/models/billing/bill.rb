module Billing
  class Bill < ActiveRecord::Base
    acts_as_paranoid if respond_to?(:acts_as_paranoid)
    has_paper_trail class_name: 'Billing::Version' if respond_to?(:has_paper_trail)
      
    monetize :charges_sum_cents
    monetize :discounts_sum_cents
    monetize :surcharges_sum_cents
    monetize :payments_sum_cents
    monetize :total_cents
    monetize :balance_cents
    
    belongs_to :billable, polymorphic: true
    has_many :charges, inverse_of: :bill, dependent: :destroy
    has_many :modifiers, inverse_of: :bill, dependent: :destroy
    has_many :payments, inverse_of: :bill, dependent: :restrict_with_error
    belongs_to :origin, inverse_of: :bills
    belongs_to :report, inverse_of: :bills
    
    if defined? Extface
      belongs_to :extface_job, class_name: 'Extface::Job'
    end
    
    accepts_nested_attributes_for :charges, :modifiers, :payments
    
    delegate :payment_model, to: :origin, prefix: :origin, allow_nil: true
    
    scope :unpaid, -> { where(arel_table[:balance_cents].lt(0)) }
    scope :open, -> { where.not(balance_cents: 0) }
    scope :partially_paid, -> { where.not( payments_sum_cents: 0, balance_cents: 0 ) }
    
    before_validation :update_sumaries
    
    before_save on: :create do
      self.number = "#{billable.id}:#{billable.billing_bills.count}"
      self.name = "B:#{number}" if name.nil?
    end
    before_save :perform_autofin, if: :becomes_paid?
    
    validates_numericality_of :total, greater_than_or_equal_to: 0
    validates_numericality_of :balance, less_than_or_equal_to: 0
    validates_presence_of :origin, if: :has_payments?
    
    validates_absence_of :payments_of_diff_models?, 
      :payments_of_diff_fiscalization?, :multiple_cash_payments?, if: :has_payments?
    
    def charge(*args)
      c = charges.new Charge.args(*args)
      c if c.save
    end
    
    def modify(*args)
      m = modifiers.new Modifier.args(*args)
      m if m.save
    end
    
    def pay(*args)
      p = build_typed_payment Payment.args(*args)
      p if p.save
    end
    
    def modifier_items
      calculate_modifiers
    end
    
    def payment_types
      billable.try(:billing_payment_types) || Billing::PaymentType.all
    end
    
    def origins
      billable.try(:billing_origins) || Billing::Origin.all
    end
    
    def has_payments?
      payments.any?
    end
    
    def paid?
      has_payments? && balance.zero?
    end
    
    def build_typed_payment(attributes = {})
      payment_origin = attributes[:origin] || origins.find_by_id(attributes[:origin_id])
      payments.new(attributes.merge(type: (payment_origin || origin).try(:payment_model) || 'Billing::PaymentWithType'))
    end
    
    def fiscalize #TODO test
      extface_job = origin.fiscal_device.fiscalize(self) if fiscalizable? && origin.try(:fiscal_device)
      extface_job if save
    end

    private
      def calculate_modifiers
        @modifier_items = ModifierItems.new.tap() do |items|
          modifiers.each do |modifier|
            if charge = modifier.charge
              charge.value = modifier.percent_ratio.nil? ? modifier.fixed_value : (charge.price * modifier.percent_ratio)
              items << Charge.new(price: charge.value, chargable: charge)
            else
              items << Charge.new(price: modifier.percent_ratio.nil? ? modifier.fixed_value : (charges.to_a.sum(&:price).to_money * modifier.percent_ratio))
            end
          end
        end
      end
      def update_sumaries
        self.charges_sum = charges.to_a.sum(&:price).to_money
        calculate_modifiers
        self.discounts_sum = -@modifier_items.discounts.sum(&:price).to_money
        self.surcharges_sum = @modifier_items.surcharges.sum(&:price).to_money
        self.payments_sum = payments.to_a.sum(&:value).to_money
        self.total = charges_sum + surcharges_sum - discounts_sum
        self.balance = payments_sum - total
      end
      
      def payments_of_diff_models?
        payments.to_a.group_by(&:type).many?
      end
      
      def payments_of_diff_fiscalization?
        payments.to_a.group_by(&:fiscal?).many?
      end
      
      def multiple_cash_payments?
        payments.to_a.select(&:cash?).many?
      end
      
      def becomes_paid?
        finalized_at.nil? && has_payments? && balance.zero?
      end
      
      def perform_autofin
        if autofin
          self.finalized_at = Time.now
          if defined? Extface
            self.extface_job = origin.fiscal_device.fiscalize(self) if fiscalizable? && origin.try(:fiscal_device)
          end
        end
        true
      end
      
      def fiscalizable?
        payments.select(&:fiscal?).any?
      end
  end
end
