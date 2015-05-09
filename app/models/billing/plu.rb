module Billing
  class Plu < ActiveRecord::Base
    monetize :price_cents
  end
end
