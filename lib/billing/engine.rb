require 'money-rails'
require 'paper_trail'

require 'collection_proxy_wild'

module Billing
  class Engine < ::Rails::Engine
    isolate_namespace Billing
  end
end
