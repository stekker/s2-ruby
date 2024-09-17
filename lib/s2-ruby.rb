require "json"
require "dry-types"
require "dry-struct"
require "active_support/all"

require_relative "s2/version"

require_relative "s2/messages/types"
require_relative "s2/schemas/number_range"

require_relative "s2/messages/frbc_actuator_status"
require_relative "s2/messages/frbc_fill_level_target_profile"
require_relative "s2/messages/frbc_instruction"
require_relative "s2/messages/frbc_leakage_behaviour"
require_relative "s2/messages/frbc_storage_status"
require_relative "s2/messages/frbc_system_description"
require_relative "s2/messages/frbc_timer_status"
require_relative "s2/messages/frbc_usage_forecast"
require_relative "s2/messages/handshake"
require_relative "s2/messages/handshake_response"
require_relative "s2/messages/reception_status"
require_relative "s2/messages/resource_manager_details"

require_relative "s2/message_factory"
require_relative "s2/message_handler"
require_relative "s2/message_handler_callbacks"
require_relative "s2/connection"

module S2
  PROTOCOL_VERSION = "0.0.2-beta".freeze

  class Error < StandardError; end
  # Your code goes here...
end
