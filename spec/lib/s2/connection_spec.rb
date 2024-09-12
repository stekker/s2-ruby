describe S2::Connection do
  let(:ws) { MockWebSocketClient.new }

  describe "#receive_message" do
    context "with invalid messages" do
      it "handles invalid JSON" do
        ws = nil
        logger = Logger.new(nil)

        expect { described_class.new(ws, logger:).receive_message("test") }
          .not_to raise_error
      end

      it "handles a missing message_type" do
        ws = nil
        logger = Logger.new(nil)
        message = {}.to_json

        expect { described_class.new(ws, logger:).receive_message(message) }
          .to raise_error(S2::MessageFactory::InvalidMessageType)
      end

      it "handles a missing message_id" do
        ws = nil
        logger = Logger.new(nil)
        message = { message_type: "Handshake" }.to_json

        expect { described_class.new(ws, logger:).receive_message(message) }
          .not_to raise_error
      end
    end

    context "when the message is a ReceptionStatus" do
      it "logs an error when the original message has not been sent" do
        logger = Logger.new(nil)
        connection = described_class.new(ws, logger:)

        allow(logger).to receive(:error)

        reception_status = build(:s2_reception_status, :invalid_content, subject_message_id: "123")
        connection.receive_message(reception_status.to_json)

        expect(logger).to have_received(:error).with("Received ReceptionStatus for unknown message ID 123")
      end

      it "does not remove the original message from the sent messages when it was not sent" do
        allow(SecureRandom).to receive(:uuid).and_return("123")

        logger = Logger.new(nil)
        connection = described_class.new(ws, logger:)

        reception_status = build(:s2_reception_status, :invalid_content, subject_message_id: "123")

        expect do
          connection.receive_message(reception_status.to_json)
        end.not_to change { connection.sent_messages.size }
      end

      it "removes the original message from the sent messages" do
        allow(SecureRandom).to receive(:uuid).and_return("123")

        logger = Logger.new(nil)
        connection = described_class.new(ws, logger:)

        connection.send_message(S2::Messages::Handshake, { role: S2::Messages::EnergyManagementRole::Cem })
        reception_status = build(:s2_reception_status, :invalid_content, subject_message_id: "123")

        expect do
          connection.receive_message(reception_status.to_json)
        end.to change { connection.sent_messages.size }.from(1).to(0)
      end

      it "closes the connection when the status is PermanentError" do
        allow(SecureRandom).to receive(:uuid).and_return("123")

        logger = Logger.new(nil)
        connection = described_class.new(ws, logger:)
        allow(connection).to receive(:close)

        connection.send_message(S2::Messages::Handshake, { role: S2::Messages::EnergyManagementRole::Cem })
        reception_status = build(:s2_reception_status, :permanent_error, subject_message_id: "123")

        connection.receive_message(reception_status.to_json)

        expect(connection).to have_received(:close)
      end
    end
  end

  describe "#close" do
    it "sends a message if present" do
      connection = described_class.new(ws, logger: Logger.new(nil))
      connection.close(message: "test")

      expect(ws).to have_sent_message("test")
    end

    it "closes the connection" do
      connection = described_class.new(ws, logger: Logger.new(nil))
      connection.close

      expect(ws).to be_closed
    end
  end
end
