module Billing
  class Modifier < ActiveRecord::Base
    include BillItem
    belongs_to :bill, inverse_of: :modifiers, validate: true
    belongs_to :charge, inverse_of: :modifier
    monetize :fixed_value_cents
    
    scope :global, -> { where(charge_id: nil) }
    
    validate :percent_or_value
    validates_uniqueness_of :charge, scope: :bill_id, allow_nil: true
    validates_uniqueness_of :bill, scope: :charge_id
    
    private
      def percent_or_value
        errors.add :percent_or_value, I18n.t('errors.messages.blank') if percent_ratio.blank? and fixed_value.zero?
        errors.add :percent_or_value, I18n.t('errors.messages.present') if percent_ratio.present? and !fixed_value.zero?
      end
      
    class << self
      def wild_args(*args)
        case when args.blank? || args.first.kind_of?(Hash) then
          {}.merge(*args)
        when args.first.kind_of?(String) then
          d = args.shift
          if d.index('%')
            #TODO parse
          end
        else
          h = { fixed_value: args.shift.to_money }
          args.any? ? h.merge(*args) : h
        end
      end
    end
  end
end
