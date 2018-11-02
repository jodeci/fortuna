# frozen_string_literal: true
require "simplecov"
SimpleCov.start "rails" do
  add_filter "app/controllers"
end

require File.expand_path("../config/environment", __dir__)
require "rails/test_help"

# Dir[Rails.root.join("test/support/**/*.rb")].each { |f| require f }

class ActiveSupport::TestCase
  include FactoryBot::Syntax::Methods
end

DatabaseRewinder.strategy = :transaction
DatabaseRewinder.clean_with(:truncation)
