require_dependency "billing/application_controller"

module Billing
  class AccountsController < ApplicationController
    before_action :set_account
    
    def index
      @accounts = billable.billing_accounts
    end
    
    def new
      @account = billable.billing_accounts.new
    end
    
    def create
      @account = billable.billing_accounts.new
      if @account.save
        redirect_to @account
      else
        render action: :new
      end
    end
    
    private
      def set_account
        @account = billable.billing_accounts.find(params[:id]) 
      end
  end
end
