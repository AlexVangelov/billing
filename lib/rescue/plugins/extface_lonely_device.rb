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
        #Resque.redis.lpush("queue:#{Resque.queue_from_class(self)}", Resque.encode(class: self, args: args))
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
