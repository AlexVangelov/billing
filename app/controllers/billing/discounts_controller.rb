require_dependency "billing/application_controller"

module Billing
  class DiscountsController < ApplicationController
    before_action :set_account

    def new
      @discount = @account.discounts.new
    end
    
    def create
      @discount = @account.discounts.new(discount_params)
      if @discount.save
        redirect_to @account
      else
        render action: :new
      end
    end
    
    private
      def set_account
        @account = billable.billing_accounts.find(params[:account_id])
      end
      
      def discount_params
        params.require(:discount).permit(:percent_ratio, :charge_id)
      end
  end
end
