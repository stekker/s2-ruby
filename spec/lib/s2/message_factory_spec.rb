describe S2::MessageFactory do
  describe ".create" do
    it "returns an instance of the Handshake message" do
      hash = {
        "message_id" => "123",
        "message_type" => "Handshake",
        "role" => "CEM",
      }
      message = described_class.create(hash)
      expect(message).to be_a(S2::Messages::Handshake)
    end

    it "returns an instance of the ResourceManagerDetails message" do
      hash = JSON.parse <<~JSON
          {
          "message_type": "ResourceManagerDetails",
          "message_id": "69b8ad18-9419-4e7f-bf04-eb5a0089e1e7",
          "resource_id": "29f1ae55-e4f1-4a38-b4e7-db2feefdbd43",
          "roles": [
            {
              "role": "ENERGY_CONSUMER",
              "commodity": "ELECTRICITY"
            }
          ],
          "instruction_processing_delay": 1000,
          "available_control_types": [
            "FILL_RATE_BASED_CONTROL"
          ],
          "currency": "EUR",
          "provides_forecast": false,
          "provides_power_measurement_types": [
            "ELECTRIC.POWER.L1"
          ]
        }
      JSON

      message = described_class.create(hash)
      expect(message).to be_a(S2::Messages::ResourceManagerDetails)
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
