FactoryBot.define do
  factory :s2_select_control_type, class: "S2::Messages::SelectControlType" do
    initialize_with do
      S2::Messages::SelectControlType.from_dynamic!(attributes.with_indifferent_access)
    end

    message_id { generate(:uuid) }
    message_type { S2::Messages::SelectControlTypeMessageType::SelectControlType }
    frbc

    trait :frbc do
      control_type { S2::Messages::ControlType::FillRateBasedControl }
    end

    trait :ddbc do
      control_type { S2::Messages::ControlType::DemandDrivenBasedControl }
    end

    trait :no_selection do
      control_type { S2::Messages::ControlType::NoSelection }
    end

    trait :not_controlable do
      control_type { S2::Messages::ControlType::NotControlable }
    end

    trait :ombc do
      control_type { S2::Messages::ControlType::OperationModeBasedControl }
    end

    trait :pebc do
      control_type { S2::Messages::ControlType::PowerEnvelopeBasedControl }
    end

    trait :ppbc do
      control_type { S2::Messages::ControlType::PowerProfileBasedControl }
    end
  end
end
