# frozen_string_literal: true
require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"

class ActiveSupport::TestCase
  include FactoryBot::Syntax::Methods
end
