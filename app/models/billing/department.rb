module Billing
  class Department < ActiveRecord::Base
    belongs_to :tax_group
  end
end
