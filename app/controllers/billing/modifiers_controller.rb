require_dependency "billing/application_controller"

module Billing
  class ModifiersController < ApplicationController
    before_action :set_account

    def new
      @modifier = @account.modifiers.new
    end
    
    def create
      @modifier = @account.modifiers.new(modifier_params)
      if @modifier.save
        redirect_to @account
      else
        render action: :new
      end
    end
    
    private
      def set_account
        @account = billable.billing_accounts.find(params[:account_id])
      end
      
      def modifier_params
        params.require(:modifier).permit(:percent_ratio, :fixed_value, :charge_id)
      end
  end
end
