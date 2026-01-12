FactoryBot.define do
  factory :s2_frbc_instruction, class: "S2::Messages::FRBCInstruction" do
    initialize_with { S2::Messages::FRBCInstruction.from_dynamic!(attributes.with_indifferent_access) }

    message_id { generate(:uuid) }
    message_type { S2::Messages::FRBCInstructionMessageType::FRBCInstruction }

    abnormal_condition { false }
    actuator_id { generate(:uuid) }
    execution_time { Time.current.iso8601 }
    id { generate(:uuid) }
    operation_mode { generate(:uuid) }
    operation_mode_factor { 1 }
  end
end
