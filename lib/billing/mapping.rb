module Billing
  class Mapping
    attr_reader :name, :i_klass, :i_param, :i_find_key, :i_extra_module
    def initialize(resource, options)
      @name = (options[:as] || resource).to_s
      
      @i_klass = (options[:billable_type] || name.to_s.classify).to_s.constantize
      
      @i_param = options[:billable_param] || "#{name.singularize}_id" #default #{resource}_id

      # key to find interfaceable in controller, when
      # :uuid then find_by! :uuid => params[:uuid]
      # :shop_uuid then find_by! :uuid => params[:shop_uuid]
      # :shop_id then find_by! :id => params[:shop_id]
      @i_find_key = @i_param[/^(#{resource}_|)(\w+)/,2]
      # FIXME not before schema load
      #raise "#{@i_klass.name} has no method #{@i_find_key}" unless @i_klass.new.respond_to? @i_find_key
      #raise "Did you forget to add 'has_extface_devices' in #{@i_klass.name} ?" unless @i_klass.new.respond_to? :extface_devices
      @i_extra_module = options[:controller_include].to_s.constantize if options[:controller_include].present?
    end
    
    def mount_point
      "#{name}_billing"
    end
    
    class << self
      def find(fullpath)
        Billing.mappings[fullpath[%r{/(\w+)_billing\/}, 1]]
      end
    end
  end
end