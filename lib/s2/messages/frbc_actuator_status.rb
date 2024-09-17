module S2
  module Messages
    module MessageType
      FRBCActuatorStatus = "FRBC.ActuatorStatus"
    end

    class FrbcActuatorStatus < Dry::Struct

      # ID of the FRBC.OperationMode that is presently active.
      attribute :active_operation_mode_id, Types::String

      # ID of the actuator this messages refers to
      attribute :actuator_id, Types::String

      # ID of this message
      attribute :message_id, Types::String

      attribute :message_type, Types::MessageType

      # The number indicates the factor with which the FRBC.OperationMode is configured. The
      # factor should be greater than or equal than 0 and less or equal to 1.
      attribute :operation_mode_factor, Types::Double

      # ID of the FRBC.OperationMode that was active before the present one. This value shall
      # always be provided, unless the active FRBC.OperationMode is the first FRBC.OperationMode
      # the Resource Manager is aware of.
      attribute :previous_operation_mode_id, Types::String.optional

      # Time at which the transition from the previous FRBC.OperationMode to the active
      # FRBC.OperationMode was initiated. This value shall always be provided, unless the active
      # FRBC.OperationMode is the first FRBC.OperationMode the Resource Manager is aware of.
      attribute :transition_timestamp, Types::String.optional

      def self.from_dynamic!(d)
        d = Types::Hash[d]
        new(
          active_operation_mode_id:   d.fetch("active_operation_mode_id"),
          actuator_id:                d.fetch("actuator_id"),
          message_id:                 d.fetch("message_id"),
          message_type:               d.fetch("message_type"),
          operation_mode_factor:      d.fetch("operation_mode_factor"),
          previous_operation_mode_id: d["previous_operation_mode_id"],
          transition_timestamp:       d["transition_timestamp"],
        )
      end

      def self.from_json!(json)
        from_dynamic!(JSON.parse(json))
      end

      def to_dynamic
        {
          "active_operation_mode_id"   => active_operation_mode_id,
          "actuator_id"                => actuator_id,
          "message_id"                 => message_id,
          "message_type"               => message_type,
          "operation_mode_factor"      => operation_mode_factor,
          "previous_operation_mode_id" => previous_operation_mode_id,
          "transition_timestamp"       => transition_timestamp,
        }
      end

      def to_json(options = nil)
        JSON.generate(to_dynamic, options)
      end
    end
  end
end
