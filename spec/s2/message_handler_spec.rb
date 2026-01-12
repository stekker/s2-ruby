describe S2::MessageHandler do
  describe "#handle_message" do
    it "invokes a registered handler for the message" do
      message_sender = instance_double(S2::MessageSender)

      message_handler_class = Class.new(S2::MessageHandler) do
        attr_reader :received_message

        on S2::Messages::Handshake do |message|
          @received_message = message
        end
      end

      handler = message_handler_class.new(message_sender:)
      message = build(:s2_handshake)

      handler.handle_message(message.to_json)
      expect(handler.received_message).to eq(message)
    end

    it "replies to errors with a fitting error reception status" do
      message_sender = instance_double(S2::MessageSender)
      allow(message_sender).to receive(:send_message)

      message_handler_class = Class.new(described_class)

      handler = message_handler_class.new(message_sender:)

      expect { handler.handle_message("<invalid_json/>") }.not_to raise_error

      expect(message_sender).to have_received(:send_message) do |reception_status|
        expect(reception_status).to have_attributes(
          message_type: S2::Messages::ReceptionStatusMessageType::ReceptionStatus,
          status: S2::Messages::ReceptionStatusValues::InvalidData,
          diagnostic_label: "Invalid JSON",
          subject_message_id: S2::MessageHandler::Replying::NULL_MESSAGE_ID,
        )
      end
    end

    it "calls before, after, and around callbacks" do
      message_sender = instance_double(S2::MessageSender)
      allow(message_sender).to receive(:send_message)

      callback_order = []

      message_handler_class = Class.new(S2::MessageHandler) do
        before_handle do |payload|
          callback_order << [:before, payload]
        end

        after_handle do |payload|
          callback_order << [:after, payload]
        end

        around_handle do |payload, inner|
          callback_order << [:around_start, payload]
          inner.call
          callback_order << [:around_end, payload]
        end

        on S2::Messages::Handshake do |message|
          callback_order << [:handler, message]
        end
      end

      handler = message_handler_class.new(message_sender:)
      message = build(:s2_handshake)

      payload = message.to_json
      handler.handle_message(payload)

      expect(callback_order).to eq(
        [
          [:before, payload],
          [:around_start, payload],
          [:handler, message],
          [:around_end, payload],
          [:after, payload],
        ],
      )
    end
  end
end
