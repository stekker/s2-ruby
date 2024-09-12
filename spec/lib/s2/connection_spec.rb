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
      it "logs an error if the status is not OK" do
        allow(SecureRandom).to receive(:uuid).and_return("123")

        logger = Logger.new(nil)
        connection = described_class.new(ws, logger:)

        allow(logger).to receive(:error)

        connection.send_message(S2::Messages::Handshake, { role: S2::Messages::EnergyManagementRole::Cem })
        reception_status = build(:s2_reception_status, :invalid_content, subject_message_id: "123")
        connection.receive_message(reception_status.to_json)

        expect(logger).to have_received(:error)
          .with(/Received ReceptionStatus with status INVALID_CONTENT for message ID 123/)
      end

      it "sends an error response when the original message is not known",
         skip: "sending this error causes an endless loop" do
           error_response = build(:s2_reception_status, :invalid_content, subject_message_id: "123")

           logger = Logger.new(nil)
           connection = described_class.new(ws, logger:)

           allow(logger).to receive(:error)

           reception_status = build(:s2_reception_status, :invalid_content, subject_message_id: "123")
           connection.receive_message(reception_status.to_json)

           expect(ws).to have_sent_message(error_response.to_json)
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
