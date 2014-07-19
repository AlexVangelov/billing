# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "rails/test_help"

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

# Load fixtures from the engine
ActiveSupport::TestCase.fixture_path = File.expand_path("../fixtures", __FILE__)


class ActiveSupport::TestCase
  # load db schema
  ActiveRecord::Schema.verbose = false
  load "#{Rails.root}/db/schema.rb"
  
  fixtures :all
end
module Billing
  class ActionController::TestCase
    setup do
      @routes = Billing::Engine.routes
    end
    module Behavior
      def process_with_profile(action, http_method = 'GET', parameters = nil, session = nil, flash = nil)
        parameters = { profile_id: profiles(:one) }.merge(parameters || {})
        process_without_profile(action, http_method, parameters, session, flash)
      end
      alias_method_chain :process, :profile
    end
  end
  class ActionDispatch::Routing::RouteSet
    def default_url_options(options={})
      options.merge(profile_id: Profile.first)
    end
  end
end
