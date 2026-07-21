module S2::MessageHandler::ErrorHandling
  extend ActiveSupport::Concern

  included do
    include ActiveSupport::Rescuable
    include S2::MessageHandler::Replying

    rescue_from StandardError do |error|
      ActiveSupport::Notifications.instrument("message_errored.session.s2", exception: error)

      reply to: error.try(:message_id), status: :temporary_error
    end

    rescue_from S2::MessageFactory::InvalidMessageFormat do |error|
      reply to: error.message_id, status: :invalid_data, diagnostic_label: error.message
    end

    rescue_from S2::MessageFactory::MissingMessageType,
                S2::MessageFactory::InvalidMessagePayload,
                S2::MessageFactory::UnsupportedMessageType do |error|
      reply to: error.message_id, status: :invalid_message, diagnostic_label: error.message
    end

    rescue_from S2::MessageHandler::Dispatching::HandlerNotFound do |_error|
      reply to: nil,
            status: :invalid_message,
            diagnostic_label: "Unsupported message type"
    end
  end
end
