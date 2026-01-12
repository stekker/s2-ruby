describe S2::MessageHandler::Replying do
  describe "::reply_with" do
    it "sets the replier to the specified method or instance variable" do
      message_handler_class = Class.new do
        include S2::MessageHandler::Replying

        reply_with :@custom_replier
      end

      expect(message_handler_class.replier).to eq(:@custom_replier)
    end
  end

  describe "#reply" do
    it "sends the reply message using the configured replier" do
      replier = instance_double(S2::MessageSender)
      allow(replier).to receive(:send_message)

      message_handler_class = Class.new do
        include S2::MessageHandler::Replying

        reply_with :@custom_replier

        def initialize(custom_replier:)
          @custom_replier = custom_replier
        end
      end

      handler = message_handler_class.new(custom_replier: replier)
      handshake = build(:s2_handshake)
      expected_reply_message = build(
        :s2_reception_status,
        status: S2::Messages::ReceptionStatusValues::InvalidMessage,
        subject_message_id: handshake.message_id,
        diagnostic_label: "Your message is completely bogus",
      )

      handler.reply(
        to: handshake,
        status: :invalid_message,
        diagnostic_label: "Your message is completely bogus",
      )

      expect(replier).to have_received(:send_message).with(expected_reply_message)
    end

    it "raises an error if an unknown status is provided" do
      message_handler_class = Class.new do
        include S2::MessageHandler::Replying

        reply_with :@custom_replier

        def initialize(custom_replier:)
          @custom_replier = custom_replier
        end
      end

      handler = message_handler_class.new(custom_replier: instance_double(S2::MessageSender))
      handshake = build(:s2_handshake)

      expect { handler.reply(to: handshake, status: :unknown_status) }
        .to raise_error(ArgumentError, /Unknown status: unknown_status/)
    end

    it "raises an error if no replier is configured" do
      message_handler_class = Class.new do
        include S2::MessageHandler::Replying
      end

      handler = message_handler_class.new
      handshake = build(:s2_handshake)

      expect { handler.reply(to: handshake, status: :ok) }
        .to raise_error(RuntimeError, /No replier configured/)
    end

    it "uses a null message ID if the 'to' message is nil" do
      replier = instance_double(S2::MessageSender)
      allow(replier).to receive(:send_message)

      message_handler_class = Class.new do
        include S2::MessageHandler::Replying

        reply_with :@custom_replier

        def initialize(custom_replier:)
          @custom_replier = custom_replier
        end
      end

      handler = message_handler_class.new(custom_replier: replier)
      expected_reply_message = build(
        :s2_reception_status,
        :ok,
        subject_message_id: S2::MessageHandler::Replying::NULL_MESSAGE_ID,
      )

      handler.reply(to: nil, status: :ok)

      expect(replier).to have_received(:send_message).with(expected_reply_message)
    end

    it "uses a null message ID if the 'to' message has no message_id" do
      replier = instance_double(S2::MessageSender)
      allow(replier).to receive(:send_message)

      message_handler_class = Class.new do
        include S2::MessageHandler::Replying

        reply_with :@custom_replier

        def initialize(custom_replier:)
          @custom_replier = custom_replier
        end
      end

      handler = message_handler_class.new(custom_replier: replier)
      message_without_id = build(:s2_handshake, message_id: "")
      expected_reply_message = build(
        :s2_reception_status,
        :ok,
        subject_message_id: S2::MessageHandler::Replying::NULL_MESSAGE_ID,
      )

      handler.reply(to: message_without_id, status: :ok)

      expect(replier).to have_received(:send_message).with(expected_reply_message)
    end
  end

  describe "#reply_ok" do
    it "sends an OK reply message using the configured replier" do
      replier = instance_double(S2::MessageSender)
      allow(replier).to receive(:send_message)

      message_handler_class = Class.new do
        include S2::MessageHandler::Replying

        reply_with :@custom_replier

        def initialize(custom_replier:)
          @custom_replier = custom_replier
        end
      end

      handler = message_handler_class.new(custom_replier: replier)
      handshake = build(:s2_handshake)
      expected_reply_message = build(
        :s2_reception_status,
        :ok,
        subject_message_id: handshake.message_id,
      )

      handler.reply_ok(to: handshake)

      expect(replier).to have_received(:send_message).with(expected_reply_message)
    end
  end
end
