require "simplecov"
SimpleCov.start "rails"
require "coveralls"
Coveralls.wear! "rails"
require "support/login_helper"
require "support/request_helper"
require "support/database_cleaner"
require "factory_girl_rails"

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.include LoginHelper, type: :request
  config.include Requests::JsonHelpers, type: :request
end
