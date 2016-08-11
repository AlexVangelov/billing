module Resque
  module Plugins
    module ExtfaceLonelyDevice
      LOCK_TIMEOUT = 60 * 60 * 24 * 5 # 5 days

      def lock_timeout
        Time.now.to_i + LOCK_TIMEOUT + 1
      end

      def requeue_interval
        self.instance_variable_get(:@requeue_interval) || 1
      end

      # Overwrite this method to uniquely identify which mutex should be used
      # for a resque worker.
      def redis_key(*args)
        "extface_"
      end

      def can_lock_queue?(*args)
        now = Time.now.to_i
        key = redis_key(*args)
        timeout = lock_timeout

        # Per http://redis.io/commands/setnx
        return true  if Resque.redis.setnx(key, timeout)
        return false if Resque.redis.get(key).to_i > now
        return true  if Resque.redis.getset(key, timeout).to_i <= now
        return false
      rescue ActiveRecord::RecordNotFound #redis_key exception
        p "Not found!!!"
        sleep 1
        reenqueue(*args) #will stop if new redis_key exception
      end

      def unlock_queue(*args)
        Resque.redis.del(redis_key(*args))
      end

      def reenqueue(*args)
        Resque.enqueue_to(redis_key(*args), self, *args)
      end

      def before_perform(*args)
        unless can_lock_queue?(*args)
          # Sleep so the CPU's rest
          sleep(requeue_interval)

          # can't get the lock, so re-enqueue the task
          reenqueue(*args)

          # and don't perform
          raise Resque::Job::DontPerform
        end
      end

      def around_perform(*args)
        begin
          yield
        ensure
          unlock_queue(*args)
        end
      end
    end
  end
end

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
        s.print "******************************\r\n*"
        s.print "Bill ##{bill.number}".center(28)
        s.print "*\r\n******************************\r\n"
        s.print "------------------------------\r\n"
        
        bill.charges.each do |charge|
          s.print "#{charge.name.ljust(22)} #{charge.value.to_s.rjust(7)}\r\n"
        end
        s.print "-----------\r\n".rjust(32)
        s.print "#{bill.total}\r\n".rjust(32)
        
        # s.print "..............................\r\n"
        # bill.payments.each do |payment|
          # s.print "#{payment.payment_type.name.humanize}\r\n"
        # end
        
        s.print "\r\n"
        s.print "------------------------------\r\n"
        s.print Time.now.strftime("Printed on %m/%d/%Y %T\r\n").rjust(32)
        s.print "\r\n\r\n\r\n"
        s.notify "Print Doc End"
      end
    rescue Resque::TermException
      reenqueue(bill_id)
    end
  end
end