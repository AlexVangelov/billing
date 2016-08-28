module Billing
  class Charge < ActiveRecord::Base
    include BillItem
    
    attr_accessor :tax_group, :plu, :department
    
    belongs_to :bill, inverse_of: :charges, validate: true
    belongs_to :chargable, polymorphic: true
    belongs_to :origin, inverse_of: :charges
    has_one :modifier, inverse_of: :charge

    monetize :price_cents, with_model_currency: :price_currency
    monetize :value_cents
    
    delegate :paid?, to: :bill
    
    scope :unpaid, -> { joins(:bill).where.not(billing_bills: { balance_cents: 0}) }
    scope :paid, -> { joins(:bill).where(billing_bills: { balance_cents: 0}) }
    scope :in_period, lambda {|from, to| where(revenue_at: from..to) }
    
    validates_presence_of :price
    validates_numericality_of :value, greater_than_or_equal_to: 0
    
    after_initialize do
      self.value = price if self.new_record? #unless modifier.present? #bill validation will update modified value
    end
    
    def find_tax_group_mapping_for(fiscal_driver) # optimize and remove me!
      if tax_groups.present? && fiscal_driver.fiscal? #if billable provides tax groups (delegate)
        tax_group = tax_groups.find_by(percent_ratio: tax_ratio)
        tax_group.tax_group_fiscal_driver_mappings.find_by(extface_driver_id: fiscal_driver.id).try(:mapping) if tax_group
      end
    end
    
    class << self
      include Billing::BillTextParser
      def wild_args(*args)
        case when args.blank? || args.first.is_a?(Hash) then
          return {}.merge(*args)
        when args.size == 1 && args.first.is_a?(String) then
          if match = args.shift.match(/(\d+[.,]\d+\*|\d+\*|)(\d+[.,]\d+[A-Z]*|\d+[A-Z]*|)(#\d+|)(@\d+|)([+-]\d+[.,]\d+\%?|[+-]\d+\%?|)(\/\S+|)/)
            qty_s, price_s, plu_s, tax_group_s, mod_s, text = match.captures
            return {
              qty: parse_qty(qty_s),
              price: price_s.to_money,
              plu: parse_plu(plu_s),
              name: parse_text(text)
            }
          end
        else
          h = { price: args.shift.to_money }
          return args.any? ? h.merge(*args) : h
        end
      end
    end
  end
end
