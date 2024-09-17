module S2
  module Messages
    module MessageType
      FRBCInstruction = "FRBC.Instruction"
    end

    class FrbcInstruction < Dry::Struct

      # Indicates if this is an instruction during an abnormal condition.
      attribute :abnormal_condition, Types::Bool

      # ID of the actuator this instruction belongs to.
      attribute :actuator_id, Types::String

      # Indicates the moment the execution of the instruction shall start. When the specified
      # execution time is in the past, execution must start as soon as possible.
      attribute :execution_time, Types::String

      # ID of the instruction. Must be unique in the scope of the Resource Manager, for at least
      # the duration of the session between Resource Manager and CEM.
      attribute :id, Types::String

      # ID of this message
      attribute :message_id, Types::String

      attribute :message_type, Types::MessageType

      # ID of the FRBC.OperationMode that should be activated.
      attribute :operation_mode, Types::String

      # The number indicates the factor with which the FRBC.OperationMode should be configured.
      # The factor should be greater than or equal to 0 and less or equal to 1.
      attribute :operation_mode_factor, Types::Double

      def self.from_dynamic!(d)
        d = Types::Hash[d]
        new(
          abnormal_condition:    d.fetch("abnormal_condition"),
          actuator_id:           d.fetch("actuator_id"),
          execution_time:        d.fetch("execution_time"),
          id:                    d.fetch("id"),
          message_id:            d.fetch("message_id"),
          message_type:          d.fetch("message_type"),
          operation_mode:        d.fetch("operation_mode"),
          operation_mode_factor: d.fetch("operation_mode_factor"),
        )
      end

      def self.from_json!(json)
        from_dynamic!(JSON.parse(json))
      end

      def to_dynamic
        {
          "abnormal_condition"    => abnormal_condition,
          "actuator_id"           => actuator_id,
          "execution_time"        => execution_time,
          "id"                    => id,
          "message_id"            => message_id,
          "message_type"          => message_type,
          "operation_mode"        => operation_mode,
          "operation_mode_factor" => operation_mode_factor,
        }
      end

      def to_json(options = nil)
        JSON.generate(to_dynamic, options)
      end
    end
  end
end
