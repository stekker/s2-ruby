require "active_support"
require "active_support/core_ext/class/attribute"
require "active_support/core_ext/hash/indifferent_access"
require "active_support/core_ext/numeric/time"
require "active_support/core_ext/object/blank"
require "active_support/callbacks"
require "active_support/concern"
require "active_support/notifications"
require "active_support/rescuable"
require "async"
require "async/http/endpoint"
require "async/notification"
require "async/queue"
require "async/websocket/client"
require "dry-struct"
require "dry-types"
require "json"
require "logger"
require "securerandom"

require_relative "s2/version"

module S2
  class << self
    attr_writer :logger, :message_handler_class, :supported_protocol_versions

    def logger
      @logger ||= Logger.new(nil)
    end

    def message_handler_class
      @message_handler_class ||= S2::MessageHandler
    end

    def supported_protocol_versions
      @supported_protocol_versions ||= ["0.0.2-beta"]
    end
  end

  class MessageHandler # rubocop:disable Lint/EmptyClass
  end
end

require_relative "s2/messages"
require_relative "s2/message_factory"
require_relative "s2/message_sender"
require_relative "s2/message_handler/base_error"
require_relative "s2/message_handler/dispatching"
require_relative "s2/message_handler/replying"
require_relative "s2/message_handler/error_handling"
require_relative "s2/message_handler/asserting"

require_relative "s2/message_handler"
require_relative "s2/session"
require_relative "s2/connection"
