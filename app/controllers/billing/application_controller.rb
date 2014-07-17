module Billing
  class ApplicationController < ActionController::Base
    prepend_before_filter :include_extra_module
    helper_method :billable
    
    def index
    end
    
    def billable
      @billable ||= billing_mapping.i_klass.find_by(billing_mapping.i_find_key => params[billing_mapping.i_param])
    end

    private
      def billing_mapping
        @billing_mapping ||= Billing::Mapping.find(request.fullpath)
      end
      
      def include_extra_module
        self.class.send(:include, billing_mapping.i_extra_module) if billing_mapping.i_extra_module.present?
      end
  end
end
