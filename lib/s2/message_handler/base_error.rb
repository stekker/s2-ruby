class S2::MessageHandler::BaseError < StandardError
  attr_reader :message_id

  def initialize(message, message_id)
    super(message)

    @message_id = message_id
  end
end
