FactoryBot.define do
  factory :s2_reception_status, class: "S2::Messages::ReceptionStatus" do
    initialize_with do
      S2::Messages::ReceptionStatus.from_dynamic!(
        attributes.stringify_keys,
      )
    end

    message_type { S2::Messages::ReceptionStatusMessageType::ReceptionStatus }
    subject_message_id { "00000000-0000-0000-0000-000000000000" }
    ok

    trait :invalid_content do
      status { S2::Messages::ReceptionStatusValues::InvalidContent }
    end

    trait :invalid_data do
      status { S2::Messages::ReceptionStatusValues::InvalidData }
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
