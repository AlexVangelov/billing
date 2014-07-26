require 'money-rails'
require 'paper_trail'
module Billing
  class Engine < ::Rails::Engine
    isolate_namespace Billing
  end
end
