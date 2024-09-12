describe S2::MessageFactory do
  describe ".create" do
    it "returns an instance of the correct message type" do
      hash = {
        "message_id" => "123",
        "message_type" => "Handshake",
        "role" => "CEM",
      }
      message = described_class.create(hash)
      expect(message).to be_a(S2::Messages::Handshake)
    end

    it "fails when no message type is given" do
      hash = {
        "message_id" => "123",
        "role" => "CEM",
      }
      expect { described_class.create(hash) }
        .to raise_error(S2::MessageFactory::InvalidMessageType, "Unknown message type: ''")
    end

    it "fails when an unknown message type is given" do
      hash = {
        "message_id" => "123",
        "message_type" => "Unknown",
        "role" => "CEM",
      }
      expect { described_class.create(hash) }
        .to raise_error(S2::MessageFactory::InvalidMessageType, "Unknown message type: 'Unknown'")
    end
  end
end
