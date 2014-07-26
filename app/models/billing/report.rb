module Billing
  class Report < ActiveRecord::Base
    
    has_paper_trail class_name: 'Billing::Version'
    belongs_to :origin, inverse_of: :reports
    has_many :accounts, inverse_of: :report, autosave: true
    belongs_to :extface_job, class_name: 'Extface::Job'
    monetize :payments_sum_cents
    monetize :payments_cash_cents
    monetize :payments_fiscal_cents
    
    validates_presence_of :origin
    validates_absence_of :partially_paid_accounts?
    before_validation :set_closure_to_account
    before_create :update_summary
    
    def fiscalization
      if origin.fiscal_device.present?
        perform_fiscal_job
        save
      end
    end
    
    private
      def set_closure_to_account
        #self.payments << origin.payments.for_closure if [KIND_SIMPLE, KIND_WITH_FP_Z].include? kind
      end
      
      def update_summary
        self.payments_sum = payments.to_a.sum(Money.new(0, 'USD'), &:value)
        self.payments_cash = payments.select{ |p| p.try(:cash?) }.sum(Money.new(0, 'USD'), &:value)
        self.payments_fiscal = payments.select{ |p| p.try(:fiscal?) }.sum(Money.new(0, 'USD'), &:value)
        perform_fiscal_job
      end
      
      def perform_fiscal_job
        if [KIND_WITH_FP_Z, KIND_ONLY_FP_Z].include? kind
          self.extface_job = origin.fiscal_device.driver.z_report_session
        elsif kind == KIND_ONLY_FP_X
          self.extface_job = origin.fiscal_device.driver.x_report_session
        elsif kind == KIND_ONLY_FP_PERIOD
          p "period"
        end
      end
      
      def partially_paid_account?
        false
      end
  end
end
