module S2::MessageHandler::Asserting
  extend ActiveSupport::Concern

  class PermanentError < S2::MessageHandler::BaseError; end
  class InvalidContent < S2::MessageHandler::BaseError; end

  included do
    include S2::MessageHandler::ErrorHandling

    rescue_from InvalidContent do |error|
      reply to: error.message_id, status: :invalid_content, diagnostic_label: error.message
    end

    rescue_from PermanentError do |error|
      reply to: error.message_id, status: :permanent_error, diagnostic_label: error.message
    end
  end

  def assert_state!(message, **expected)
    expected.each do |key, value|
      actual = @state[key]
      next if actual == value

      raise(
        PermanentError.new(
          "Invalid state: expected #{key} to be '#{value}', got '#{actual}'",
          message.message_id,
        ),
      )
    end
  end

  def assert_attribute!(message, **expected)
    expected.each do |key, value|
      actual = message.public_send(key)
      next if actual == value

      raise(
        PermanentError.new(
          "Invalid attribute: expected #{key} to be '#{value}', got '#{actual}'",
          message.message_id,
        ),
      )
    end
  end
end
