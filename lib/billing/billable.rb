module Billing
  module Billable
    extend ActiveSupport::Concern
    
    def composite_id
      "#{(self.class.try(:base_class) || self.class).send(:name)}##{self.id}"
    end
    
    module ClassMethods
      def has_billing(options={})
        payment_types_scope = options.delete(:payment_types)
        has_many :billing_accounts, options.merge(as: :billable).reverse_merge(class_name: 'Billing::Account')
        provide_billing_items(:billing_accounts)
        if options[:as]
          has_many options[:as], options.merge(as: :billable).reverse_merge(class_name: 'Billing::Account')
          provide_billing_items(options[:as])
        end
        if payment_types_scope.present?
          define_method :billing_payment_types do
            payment_types_scope
          end
        end
      end

      private
        def provide_billing_items(association_name)
          has_many "#{association_name}_charges".intern, class_name: 'Billing::Charge', through: association_name, source: :charges
          has_many "#{association_name}_payments".intern, class_name: 'Billing::Payment', through: association_name, source: :payments
        end
    end

  end
end
ActiveRecord::Base.send :include, Billing::Billable