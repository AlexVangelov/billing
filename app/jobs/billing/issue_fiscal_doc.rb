require 'rescue/plugins/extface_lonely_device'

module Billing
  class IssueFiscalDoc
    extend Resque::Plugins::ExtfaceLonelyDevice
    
    def self.redis_key(bill_id)
      "extface_#{Bill.find(bill_id).extface_job.device_id}"
    end

    def self.perform(bill_id)
      bill = Bill.find(bill_id)
      qname = "extface_#{bill.extface_job.device_id}"
      wjs = Resque::Worker.working.find_all{ |w| w.job && w.job['queue'] == qname }
      
      p "############################"
      p "d: #{bill.extface_job.device_id} Issue Fiscal Doc ##{bill_id}, job: #{bill.extface_job_id}, wjs: #{wjs.inspect}"
      p "____________________________"
      p "active jobs: #{bill.extface_job.device.jobs.active.count}"
      

        bill.extface_job.runtime do |s|
          return unless bill.fiscalizable?
          operator_mapping = bill.find_operator_mapping_for(s)
          s.notify "Fiscal Doc Start"
          s.autofix_unclosed_doc
          s.open_fiscal_doc(operator_mapping.try(:mapping), operator_mapping.try(:pwd))
          s.notify "Register Sale"
          bill.charges.each do |charge|
            neto, percent_ratio = nil, nil, nil
            if modifier = charge.modifier
              neto = modifier.fixed_value
              percent_ratio = modifier.percent_ratio unless neto.present?
            end
            if charge.price.zero? #printing comments with zero charges (TODO check zero charges allowed?)
              s.add_comment charge.text
            else
              s.add_sale(
                s.class::SaleItem.new(
                  price: charge.price.to_f, 
                  text1: charge.name,
                  text2: charge.description,
                  tax_group: charge.find_tax_group_mapping_for(s), #find tax group mapping by ratio , not nice
                  qty: charge.qty.try(:to_f),
                  neto: neto,
                  percent_ratio: percent_ratio #TODO check format
                )
              )
            end
          end
          if bill.modifiers.global.any?
            s.notify "Register Global Modifier"
            global_modifier = bill.modifiers.global.first
            s.add_total_modifier bill.global_modifier_value.try(:to_f), global_modifier.percent_ratio.try(:to_f)
          end
          s.notify "Register Payment"
          bill.payments.each do |payment|
            s.add_payment payment.value.to_f, payment.find_payment_type_mapping_for(s)
          end
          s.notify "Close Fiscal Receipt"
          s.close_fiscal_doc
          s.notify "Fiscal Doc End"
        end
    rescue Resque::TermException
      reenqueue(bill_id)
    end
  end
end