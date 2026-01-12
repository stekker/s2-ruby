describe S2::MessageHandler::ErrorHandling do
  it "replies to InvalidMessageFormat with invalid_data status" do
    test_class = Class.new do
      include S2::MessageHandler::ErrorHandling

      reply_with :@message_sender

      def initialize(message_sender:)
        @message_sender = message_sender
      end

      def test_method
        raise S2::MessageFactory::InvalidMessageFormat.new("test_id", "Invalid format")
      end
    end

    message_sender = instance_double(S2::MessageSender)
    handler = test_class.new(message_sender: message_sender)
    allow(message_sender).to receive(:send_message)

    handler.rescue_with_handler(S2::MessageFactory::InvalidMessageFormat.new("Invalid format", "test_id"))

    expect(message_sender).to have_received(:send_message) do |message|
      expect(message).to be_a(S2::Messages::ReceptionStatus)
      expect(message).to have_attributes(
        subject_message_id: "test_id",
        status: S2::Messages::ReceptionStatusValues::InvalidData,
        diagnostic_label: "Invalid format",
      )
    end
  end

  it "replies to MissingMessageType with invalid_message status" do
    test_class = Class.new do
      include S2::MessageHandler::ErrorHandling

      reply_with :@message_sender

      def initialize(message_sender:)
        @message_sender = message_sender
      end

      def test_method
        raise S2::MessageFactory::MissingMessageType.new("test_id", "Missing type")
      end
    end

    message_sender = instance_double(S2::MessageSender)
    handler = test_class.new(message_sender: message_sender)
    allow(message_sender).to receive(:send_message)

    handler.rescue_with_handler(S2::MessageFactory::MissingMessageType.new("Missing type", "test_id"))

    expect(message_sender).to have_received(:send_message) do |message|
      expect(message).to be_a(S2::Messages::ReceptionStatus)
      expect(message).to have_attributes(
        subject_message_id: "test_id",
        status: S2::Messages::ReceptionStatusValues::InvalidMessage,
        diagnostic_label: "Missing type",
      )
    end
  end

  it "replies to InvalidMessagePayload with invalid_message status" do
    test_class = Class.new do
      include S2::MessageHandler::ErrorHandling

      reply_with :@message_sender

      def initialize(message_sender:)
        @message_sender = message_sender
      end

      def test_method
        raise S2::MessageFactory::InvalidMessagePayload.new("test_id", "Invalid payload")
      end
    end

    message_sender = instance_double(S2::MessageSender)
    handler = test_class.new(message_sender: message_sender)
    allow(message_sender).to receive(:send_message)

    handler.rescue_with_handler(S2::MessageFactory::InvalidMessagePayload.new("Invalid payload", "test_id"))

    expect(message_sender).to have_received(:send_message) do |message|
      expect(message).to be_a(S2::Messages::ReceptionStatus)
      expect(message).to have_attributes(
        subject_message_id: "test_id",
        status: S2::Messages::ReceptionStatusValues::InvalidMessage,
        diagnostic_label: "Invalid payload",
      )
    end
  end

  it "replies to UnsupportedMessageType with invalid_message status" do
    test_class = Class.new do
      include S2::MessageHandler::ErrorHandling

      reply_with :@message_sender

      def initialize(message_sender:)
        @message_sender = message_sender
      end

      def test_method
        raise S2::MessageFactory::UnsupportedMessageType.new("test_id", "Unsupported type")
      end
    end

    message_sender = instance_double(S2::MessageSender)
    handler = test_class.new(message_sender: message_sender)
    allow(message_sender).to receive(:send_message)

    handler.rescue_with_handler(S2::MessageFactory::UnsupportedMessageType.new("Unsupported type", "test_id"))

    expect(message_sender).to have_received(:send_message) do |message|
      expect(message).to be_a(S2::Messages::ReceptionStatus)
      expect(message).to have_attributes(
        subject_message_id: "test_id",
        status: S2::Messages::ReceptionStatusValues::InvalidMessage,
        diagnostic_label: "Unsupported type",
      )
    end
  end

  it "replies to HandlerNotFound with invalid_message status" do
    instance_double(S2::Messages::Handshake, message_type: "UnknownType", message_id: "test_id")

    test_class = Class.new do
      include S2::MessageHandler::ErrorHandling

      reply_with :@message_sender

      def initialize(message_sender:)
        @message_sender = message_sender
      end

      def test_method
        raise S2::MessageHandler::Dispatching::HandlerNotFound.new(message, "test_id")
      end
    end

    message_sender = instance_double(S2::MessageSender)
    handler = test_class.new(message_sender: message_sender)

    allow(message_sender).to receive(:send_message)

    handler.rescue_with_handler(
      S2::MessageHandler::Dispatching::HandlerNotFound.new("Handler not found!"),
    )

    expect(message_sender).to have_received(:send_message) do |message|
      expect(message).to be_a(S2::Messages::ReceptionStatus)
      expect(message).to have_attributes(
        subject_message_id: S2::MessageHandler::Replying::NULL_MESSAGE_ID,
        status: S2::Messages::ReceptionStatusValues::InvalidMessage,
        diagnostic_label: "Unsupported message type",
      )
    end
  end

  it "replies to StandardError with temporary_error status" do
    test_class = Class.new do
      include S2::MessageHandler::ErrorHandling

      reply_with :@message_sender

      def initialize(message_sender:)
        @message_sender = message_sender
      end

      def test_method
        raise StandardError, "General error"
      end
    end

    message_sender = instance_double(S2::MessageSender)
    handler = test_class.new(message_sender: message_sender)
    allow(message_sender).to receive(:send_message)

    begin
      raise "General error"
    rescue StandardError => e
      exception = e
    end

    handler.rescue_with_handler(exception)

    expect(message_sender).to have_received(:send_message) do |message|
      expect(message).to be_a(S2::Messages::ReceptionStatus)
      expect(message).to have_attributes(
        subject_message_id: S2::MessageHandler::Replying::NULL_MESSAGE_ID,
        status: S2::Messages::ReceptionStatusValues::TemporaryError,
        diagnostic_label: nil,
      )
    end
  end

  it "emits notification when rescuing StandardError" do
    test_class = Class.new do
      include S2::MessageHandler::ErrorHandling

      reply_with :@message_sender

      def initialize(message_sender:)
        @message_sender = message_sender
      end

      def test_method
        raise StandardError, "General error"
      end
    end

    message_sender = instance_double(S2::MessageSender)
    handler = test_class.new(message_sender: message_sender)
    allow(message_sender).to receive(:send_message)

    begin
      raise "General error"
    rescue StandardError => e
      exception = e
    end

    callback = ->(*args) do
      event = ActiveSupport::Notifications::Event.new(*args)
      expect(event.name).to eq("message_errored.session.s2")
      expect(event.payload[:exception]).to eq(exception)
    end

    ActiveSupport::Notifications.subscribed(callback, "message_errored.session.s2") do
      handler.rescue_with_handler(exception)
    end
  end
end
