module Billing
  class Modifier < ActiveRecord::Base
    include AccountItem
    belongs_to :account, inverse_of: :modifiers, validate: true
    belongs_to :charge
    monetize :fixed_value_cents
    
    validate :percent_or_value
    
    class << self
      def args_to_attributes(*args)
        case args.first.class
        when Hash then
          {}.merge(*args)
        when String then
          d = args.shift
          if d.index('%')
            
          end
        else
          h = { price: args.shift.to_money }
          args.any? ? h.merge(*args) : h
        end
      end
    end
    
    private
      def percent_or_value
        errors.add :percent_or_value, I18n.t('errors.messages.blank') if percent_ratio.blank? and fixed_value.zero?
        errors.add :percent_or_value, I18n.t('errors.messages.present') if percent_ratio.present? and !fixed_value.zero?
      end
  end
end
