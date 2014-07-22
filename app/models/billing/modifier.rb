module Billing
  class Modifier < ActiveRecord::Base
    include AccountItem
    belongs_to :account, inverse_of: :modifiers, validate: true
    belongs_to :charge
    monetize :fixed_value_cents
    
    validate :percent_or_value
    validates_uniqueness_of :charge, scope: :account_id, allow_nil: true
    validates_uniqueness_of :account, scope: :charge_id
    
    private
      def percent_or_value
        errors.add :percent_or_value, I18n.t('errors.messages.blank') if percent_ratio.blank? and fixed_value.zero?
        errors.add :percent_or_value, I18n.t('errors.messages.present') if percent_ratio.present? and !fixed_value.zero?
      end
      
    class << self
      def args(*args)
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
