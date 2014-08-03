require "billing/engine"
require "billing/billable"

module Billing
  mattr_reader :mappings
  @@mappings = ActiveSupport::OrderedHash.new
  
  class << self
    def setup
      yield self
    end

    def add_mapping(resource, options)
      mapping = Billing::Mapping.new(resource, options)
      @@mappings[mapping.name] = mapping
    end
  end
end
