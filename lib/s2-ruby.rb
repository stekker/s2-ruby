require "json"
require "dry-types"
require "dry-struct"
require "active_support/all"

require_relative "s2/version"

require_relative "s2/messages/types"
Dir[File.join(__dir__, 's2/schemas', '*.rb')].each { |file| require_relative file }
Dir[File.join(__dir__, 's2/messages', '*.rb')].each { |file| require_relative file }

require_relative "s2/message_factory"
require_relative "s2/message_handler"
require_relative "s2/message_handler_callbacks"
require_relative "s2/connection"

module S2
  PROTOCOL_VERSION = "0.0.2-beta".freeze

  class Error < StandardError; end
  # Your code goes here...
end
