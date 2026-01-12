describe S2::MessageHandler::Dispatching do
  describe "::on" do
    it "registers a handler for the specified message class" do
      handler_block = proc {}

      message_handler_class = Class.new do
        include S2::MessageHandler::Dispatching

        on S2::Messages::Handshake, &handler_block
      end

      expect(message_handler_class.handlers[S2::Messages::Handshake.name]).to eq(handler_block)
    end

    it "raises an error when defining a second handler for the same message" do
      handler_block = proc {}

      message_handler_class = Class.new do
        include S2::MessageHandler::Dispatching

        on S2::Messages::Handshake, &handler_block
      end

      expect { message_handler_class.on(S2::Messages::Handshake, &handler_block) }
        .to raise_error(/Handler already registered for S2::Messages::Handshake/)
    end
  end

  describe "#dispatch_message" do
    it "invokes the registered handler for the message" do
      handler_invoked = false
      handler_block = proc { |message| handler_invoked = message.instance_of?(S2::Messages::Handshake) }

      message_handler_class = Class.new do
        include S2::MessageHandler::Dispatching

        on S2::Messages::Handshake, &handler_block
      end

      handler = message_handler_class.new
      message = build(:s2_handshake)

      handler.dispatch_message(message)
      expect(handler_invoked).to be true
    end

    it "raises an error if no handler is registered for the message" do
      message_handler_class = Class.new do
        include S2::MessageHandler::Dispatching
      end

      handler = message_handler_class.new
      message = build(:s2_handshake)

      expect { handler.dispatch_message(message) }
        .to raise_error(
          S2::MessageHandler::Dispatching::HandlerNotFound,
          /No handler registered for S2::Messages::Handshake/,
        )
    end

    it "raises an error if no handler is registered for a message without message_id" do
      message_handler_class = Class.new do
        include S2::MessageHandler::Dispatching
      end

      handler = message_handler_class.new
      message = build(:s2_reception_status)

      expect { handler.dispatch_message(message) }
        .to raise_error(
          S2::MessageHandler::Dispatching::HandlerNotFound,
          /No handler registered for S2::Messages::ReceptionStatus/,
        )
    end

    it "allows passing a custom type" do
      handler_invoked = false
      handler_block = proc { |message| handler_invoked = message.instance_of?(S2::Messages::Handshake) }

      message_handler_class = Class.new do
        include S2::MessageHandler::Dispatching

        on "my_custom_message_type", &handler_block
      end

      handler = message_handler_class.new
      message = build(:s2_handshake)

      handler.dispatch_message(message, type: "my_custom_message_type")
      expect(handler_invoked).to be true
    end

    it "raises an ArgumentError when the specified type is nil" do
      message_handler_class = Class.new do
        include S2::MessageHandler::Dispatching
      end

      handler = message_handler_class.new
      message = build(:s2_handshake)

      expect { handler.dispatch_message(message, type: nil) }
        .to raise_error(ArgumentError, "Missing message type")
    end

    it "raises an ArgumentError when the specified type is blank" do
      message_handler_class = Class.new do
        include S2::MessageHandler::Dispatching
      end

      handler = message_handler_class.new
      message = build(:s2_handshake)

      expect { handler.dispatch_message(message, type: "") }
        .to raise_error(ArgumentError, "Missing message type")
    end
  end
end
