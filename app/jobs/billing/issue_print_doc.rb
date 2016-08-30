require 'rescue/plugins/extface_lonely_device'

module Billing
  class IssuePrintDoc
    extend Resque::Plugins::ExtfaceLonelyDevice
    
    def self.redis_key(bill_id)
      "extface_#{Bill.find(bill_id).print_job.device_id}"
    end

    def self.perform(bill_id)
      bill = Bill.find(bill_id)
      qname = "extface_#{bill.print_job.device_id}"
      wjs = Resque::Worker.working.find_all{ |w| w.job && w.job['queue'] == qname }
      
      p "############################"
      p "d: #{bill.print_job.device_id} Issue Print Doc ##{bill_id}, job: #{bill.print_job_id}, wjs: #{wjs.inspect}"
      p "____________________________"
      p "active jobs: #{bill.print_job.device.jobs.active.count}"
      

      bill.print_job.runtime do |s|
        return unless bill.printable?
        s.notify "Print Doc Start"
        
        s.print bill.origin.print_header
        s.print "\r\n            ******            \r\n"
        s.print bill.name
        s.print "\r\n------------------------------\r\n"
        
        bill.charges.each do |charge|
          text = "#{charge.qty ? charge.qty : 1} x #{charge.name}"
          s.print "\r\n#{text.truncate(22).ljust(22)} #{charge.price.to_s.rjust(7)}\r\n"
          if charge.description
            s.print "#{charge.description.truncate(26)}\r\n"
          end
          if charge.modifier.present?
            text = charge.modifier.percent_ratio.nil? ? "" : " #{charge.modifier.percentage}"
            if charge.modifier.positive?
              text += " #{ bill.origin.receipt_config ? bill.origin.receipt_config.surcharge_text || 'Surcharge' : 'Surcharge' }"
            else
              text += " #{ bill.origin.receipt_config ? bill.origin.receipt_config.discount_text || 'Discount' : 'Discount' }"
            end
            s.print "#{text.ljust(22)} #{(charge.value - charge.price).to_s.rjust(7)}\r\n"
          end
        end
        s.print "-----------\r\n".rjust(32)
        if bill.modifiers.global.any?
          global_modifier = bill.modifiers.global.first
          text = global_modifier.percent_ratio.nil? ? "" : " #{global_modifier.percentage}"
          if global_modifier.positive?
            text += " #{ bill.origin.receipt_config ? bill.origin.receipt_config.surcharge_text || 'Surcharge' : 'Surcharge' }"
          else
            text += " #{ bill.origin.receipt_config ? bill.origin.receipt_config.discount_text || 'Discount' : 'Discount' }"
          end
          s.print "#{text.ljust(22)} #{bill.global_modifier_value.to_s.rjust(7)}\r\n"
        end
        s.print "TOTAL:    #{bill.total.to_s.rjust(20)}\r\n"
        
        # s.print "..............................\r\n"
        # bill.payments.each do |payment|
          # s.print "#{payment.payment_type.name.humanize}\r\n"
        # end

        s.print "            ******            \r\n"
        s.print bill.origin.print_footer
        s.print "\r\n------------------------------\r\n"
        s.print Time.now.strftime("Printed on %m/%d/%Y %T\r\n").rjust(32)
        s.print "\r\n\r\n\r\n"
        s.notify "Print Doc End"
      end
    rescue Resque::TermException
      reenqueue(bill_id)
    end
  end
end