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
        s.print "#{bill.name}".truncate(30)
        s.print "\r\n------------------------------\r\n"
        
        bill.charges.each do |charge|
          s.print "#{charge.name.ljust(22)} #{charge.value.to_s.rjust(7)}\r\n"
          if charge.modifier.present?
            s.print "  Item modifier:     #{charge.modifier.human.to_s.rjust(7)}\r\n"
          end
        end
        if bill.modifiers.any?
          s.print "  Global modifier:   #{bill.global_modifier_value.to_s.rjust(7)}\r\n"
        end
        s.print "-----------\r\n".rjust(32)
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