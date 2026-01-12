FactoryBot.define do
  factory :s2_handshake_response, class: "S2::Messages::HandshakeResponse" do
    initialize_with { S2::Messages::HandshakeResponse.from_dynamic!(attributes.with_indifferent_access) }

    message_id { generate(:uuid) }
    message_type { S2::Messages::HandshakeResponseMessageType::HandshakeResponse }
    selected_protocol_version { "0.0.2-beta" }
  end
end
