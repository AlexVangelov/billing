module Billing
  class Version < PaperTrail::Version
    self.table_name = :billing_versions
    
    belongs_to :changable, -> { with_deleted }, polymorphic: true, foreign_key: :item_id, foreign_type: :item_type
  end
end