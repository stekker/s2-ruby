require "simplecov"
require "simplecov-lcov"

SimpleCov::Formatter::LcovFormatter.config do |config|
  config.report_with_single_file = true
  config.single_report_path = "coverage/lcov.info"
end

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new(
  [
    SimpleCov::Formatter::HTMLFormatter,
    SimpleCov::Formatter::LcovFormatter,
  ],
)

SimpleCov.start do
  add_filter "/spec/"
  add_filter "lib/s2/messages.rb"
  enable_coverage :branch
end

require "coveralls"
Coveralls.wear! if ENV["CI"]

require "rspec"
require "factory_bot"
require "s2"

Dir[File.join(__dir__, "support/**/*.rb")].each { |f| require f }
Dir[File.join(__dir__, "factories/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  config.example_status_persistence_file_path = ".rspec_status"

  config.include FactoryBot::Syntax::Methods

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
