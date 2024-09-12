FactoryBot.define do
  factory :s2_reception_status, class: "S2::Messages::ReceptionStatus" do
    initialize_with { S2::Messages::ReceptionStatus.from_dynamic!(attributes.with_indifferent_access) }
    message_type { S2::Messages::MessageType::ReceptionStatus }
    subject_message_id { "factory_bot" }
    ok

    trait :invalid_content do
      status { S2::Messages::ReceptionStatusValues::InvalidContent }
    end

    trait :invalid_message do
      status { S2::Messages::ReceptionStatusValues::InvalidMessage }
    end

    trait :ok do
      status { S2::Messages::ReceptionStatusValues::Ok }
    end

    trait :permanent_error do
      status { S2::Messages::ReceptionStatusValues::PermanentError }
    end
  end
end
