require_dependency "billing/application_controller"

module Billing
  class ChargesController < ApplicationController
    before_action :set_account

    def new
      @charge = @account.charges.new
    end
    
    def create
      @charge = @account.charges.new(charge_params)
      if @charge.save
        redirect_to @account
      else
        render action: :new
      end
    end
    
    private
      def set_account
        @account = billable.billing_accounts.find(params[:account_id])
      end
      
      def charge_params
        params.require(:charge).permit(:price)
      end
  end
end
