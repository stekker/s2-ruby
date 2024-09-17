module S2
  module Messages
    module MessageType
      FRBCTimerStatus = "FRBC.TimerStatus"
    end

    class FrbcTimerStatus < Dry::Struct

      # The ID of the actuator the timer belongs to
      attribute :actuator_id, Types::String

      # Indicates when the Timer will be finished. If the DateTimeStamp is in the future, the
      # timer is not yet finished. If the DateTimeStamp is in the past, the timer is finished. If
      # the timer was never started, the value can be an arbitrary DateTimeStamp in the past.
      attribute :finished_at, Types::String

      # ID of this message
      attribute :message_id, Types::String

      attribute :message_type, Types::MessageType

      # The ID of the timer this message refers to
      attribute :timer_id, Types::String

      def self.from_dynamic!(d)
        d = Types::Hash[d]
        new(
          actuator_id:  d.fetch("actuator_id"),
          finished_at:  d.fetch("finished_at"),
          message_id:   d.fetch("message_id"),
          message_type: d.fetch("message_type"),
          timer_id:     d.fetch("timer_id"),
        )
      end

      def self.from_json!(json)
        from_dynamic!(JSON.parse(json))
      end

      def to_dynamic
        {
          "actuator_id"  => actuator_id,
          "finished_at"  => finished_at,
          "message_id"   => message_id,
          "message_type" => message_type,
          "timer_id"     => timer_id,
        }
      end

      def to_json(options = nil)
        JSON.generate(to_dynamic, options)
      end
    end
  end
end
