module Billing
  class Version < PaperTrail::Version
    self.table_name = :billing_versions
  end
end