FactoryBot.define do
  factory :s2_handshake, class: "S2::Messages::Handshake" do
    initialize_with { S2::Messages::Handshake.from_dynamic!(attributes.with_indifferent_access) }
    message_id { "factory_bot" }
    message_type { S2::Messages::MessageType::Handshake }
    rm
    supported_protocol_versions { [S2::PROTOCOL_VERSION] }

    trait :cem do
      role { S2::Messages::EnergyManagementRole::Cem }
    end

    trait :rm do
      role { S2::Messages::EnergyManagementRole::Rm }
    end
  end
end
