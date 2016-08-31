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

        s.print "#{bill.origin.print_header}\r\n"
        s.print_center_row "******"
        s.print "#{bill.name}\r\n"
        s.print_fill_row "-"
        
        bill.charges.each_with_index do |charge, index|
          s.print "\r\n" unless index == 0
          s.print_text_price_row "#{charge.qty ? charge.qty : 1} x #{charge.name}", charge.price
          if charge.description
            s.print_ljust_row charge.description, ' ', 4
          end
          if charge.modifier.present?
            text = charge.modifier.percent_ratio.nil? ? "" : " #{charge.modifier.percentage}"
            if charge.modifier.positive?
              text += " #{ bill.origin.receipt_config ? bill.origin.receipt_config.surcharge_text || 'Surcharge' : 'Surcharge' }"
            else
              text += " #{ bill.origin.receipt_config ? bill.origin.receipt_config.discount_text || 'Discount' : 'Discount' }"
            end
            s.print_text_price_row text, (charge.value - charge.price)
          end
        end
        s.print_rjust_row "-----------"
        if bill.modifiers.global.any?
          global_modifier = bill.modifiers.global.first
          text = global_modifier.percent_ratio.nil? ? "" : " #{global_modifier.percentage}"
          if global_modifier.positive?
            text += " #{ bill.origin.receipt_config ? bill.origin.receipt_config.surcharge_text || 'Surcharge' : 'Surcharge' }"
          else
            text += " #{ bill.origin.receipt_config ? bill.origin.receipt_config.discount_text || 'Discount' : 'Discount' }"
          end
          s.print_text_price_row text, bill.global_modifier_value
        end
        s.print_text_price_row "TOTAL:", bill.total

        s.print_center_row "******"
        s.print "#{bill.origin.print_footer}\r\n"
        s.print_fill_row "-"
        s.print_edges_row bill.number, Time.now.strftime("%Y-%d-%m %T")
        s.print "\r\n\r\n\r\n"
        s.try :autocut
        s.notify "Print Doc End"
      end
    rescue Resque::TermException
      reenqueue(bill_id)
    end
  end
end