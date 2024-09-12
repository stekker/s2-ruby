require "simplecov"

SimpleCov.start do
  add_filter "/spec/"
end

require "factory_bot"
require "s2-ruby"

require_relative "support/mock_web_socket_client"

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.before :suite do
    FactoryBot.find_definitions
  end

  config.include FactoryBot::Syntax::Methods

  config.disable_monkey_patching!
  config.example_status_persistence_file_path = "spec/examples.txt"
  config.expose_dsl_globally = true
  config.filter_run_when_matching :focus
  config.order = :random
  config.profile_examples = 10
  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.warnings = true

  config.default_formatter = "doc" if config.files_to_run.one?

  Kernel.srand config.seed
end
