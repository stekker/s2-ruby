require "json"
require "dry-types"
require "dry-struct"
require "active_support/all"

require_relative "s2/version"
require_relative "s2/messages/types"
require_relative "s2/messages/handshake"
require_relative "s2/messages/handshake_response"
require_relative "s2/messages/reception_status"
require_relative "s2/message_factory"
require_relative "s2/message_handler"
require_relative "s2/connection"

module S2
  class Error < StandardError; end
  # Your code goes here...
end
