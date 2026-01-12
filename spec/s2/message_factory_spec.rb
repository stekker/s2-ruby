describe S2::MessageFactory do
  describe "::create_message" do
    it "creates a message object from valid JSON data" do
      json_data = <<~JSON
        {
          "message_type": "Handshake",
          "message_id": "ce7b430c-25be-41ec-b97c-ac0258aff498",
          "role": "RM",
          "supported_protocol_versions": ["1.0", "1.1"]
        }
      JSON

      message = described_class.create_message(json_data)

      expect(message).to be_a(S2::Messages::Handshake)

      expect(message).to have_attributes(
        message_type: "Handshake",
        message_id: "ce7b430c-25be-41ec-b97c-ac0258aff498",
        role: "RM",
        supported_protocol_versions: %w[1.0 1.1],
      )
    end

    it "raises InvalidMessageFormatError for invalid JSON data" do
      invalid_json_data = "{ invalid json }"

      expect { described_class.create_message(invalid_json_data) }
        .to raise_error(S2::MessageFactory::InvalidMessageFormat, "Invalid JSON")
    end

    it "raises MissingMessageTypeError when message_type is missing" do
      json_data = <<~JSON
        {
          "message_id": "ce7b430c-25be-41ec-b97c-ac0258aff498",
          "role": "RM",
          "supported_protocol_versions": ["1.0", "1.1"]
        }
      JSON

      expect { described_class.create_message(json_data) }
        .to raise_error(S2::MessageFactory::MissingMessageType, "Message type not provided")
    end

    it "raises UnsupportedMessageTypeError for unsupported message_type" do
      json_data = <<~JSON
        {
          "message_type": "UnknownType",
          "message_id": "ce7b430c-25be-41ec-b97c-ac0258aff498",
          "role": "RM",
          "supported_protocol_versions": ["1.0", "1.1"]
        }
      JSON

      expect { described_class.create_message(json_data) }
        .to raise_error(S2::MessageFactory::UnsupportedMessageType, /Message type not supported: UnknownType/)
    end

    it "raises InvalidMessagePayloadError for missing required fields" do
      json_data = <<~JSON
        {
          "message_type": "Handshake",
          "message_id": "ce7b430c-25be-41ec-b97c-ac0258aff498",
          "supported_protocol_versions": ["1.0", "1.1"]
        }
      JSON

      expect { described_class.create_message(json_data) }
        .to raise_error(S2::MessageFactory::InvalidMessagePayload, /Field missing in payload: role/)
    end
  end
end
