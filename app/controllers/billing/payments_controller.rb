require_dependency "billing/application_controller"

module Billing
  class PaymentsController < ApplicationController
    before_action :set_account

    def new
      @payment = @account.payments.new(value: @account.total)
    end
    
    def create
      @payment = @account.payments.new(payment_params)
      if @payment.save
        redirect_to @account
      else
        render action: :new
      end
    end
    
    private
      def set_account
        @account = billable.billing_accounts.find(params[:account_id])
      end
      
      def payment_params
        params.require(:payment).permit(:value)
      end
  end
end
