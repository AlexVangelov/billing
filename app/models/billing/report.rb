module Billing
  class Report < ActiveRecord::Base
    FISCAL_X_REPORT = 'x_report'.freeze
    FISCAL_Z_REPORT = 'z_report'.freeze
    FISCAL_PERIOD_REPORT = 'period_report'.freeze
    F_OPERATIONS = [FISCAL_X_REPORT, FISCAL_Z_REPORT, FISCAL_PERIOD_REPORT].freeze
      
    has_paper_trail class_name: 'Billing::Version'
    belongs_to :origin, inverse_of: :reports
    has_many :bills, inverse_of: :report, autosave: true
    belongs_to :extface_job, class_name: 'Extface::Job'
    has_many :payments, through: :bills

    monetize :payments_sum_cents
    monetize :payments_cash_cents
    monetize :payments_fiscal_cents
    
    validates_presence_of :origin
    validates_absence_of :partially_paid_bills?
    validates :f_operation, inclusion: { in: F_OPERATIONS }, allow_nil: true
    validates_presence_of :f_period_from, :f_period_to, if: :fiscal_period_report?
    
    before_validation :set_report_to_bills
    before_create :update_summary
    
    
    def fiscalization
      if origin.fiscal_device.present?
        perform_fiscal_job
        save
      end
    end
    
    private
    
      def fiscal_period_report?
        f_operation == FISCAL_PERIOD_REPORT
      end
      
      def set_report_to_bills
        self.bills << origin.bills.select(&:paid?) if zeroing?
      end
      
      def update_summary
        self.payments_sum = bills.to_a.sum(Money.new(0, 'USD'), &:payments_sum)
        self.payments_cash = payments.select{ |p| p.try(:cash?) }.sum(Money.new(0, 'USD'), &:value)
        self.payments_fiscal = payments.select{ |p| p.try(:fiscal?) }.sum(Money.new(0, 'USD'), &:value)
        perform_fiscal_job
      end
      
      def perform_fiscal_job
        case f_operation
        when FISCAL_Z_REPORT then
          self.extface_job = origin.fiscal_device.driver.z_report_session
        when FISCAL_X_REPORT then
          self.extface_job = origin.fiscal_device.driver.x_report_session
        when FISCAL_PERIOD_REPORT then
          p "period"
        end
      end
      
      def partially_paid_bills?
        bills.partially_paid.any?
      end
  end
end
