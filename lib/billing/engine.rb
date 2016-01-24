require 'money-rails'
require 'paper_trail'

require 'collection_proxy_wild'

module Billing
  class Engine < ::Rails::Engine
    isolate_namespace Billing
    config.to_prepare do
      PaperTrail::Version.module_eval do
        self.abstract_class = true
      end
    end
  end
end
