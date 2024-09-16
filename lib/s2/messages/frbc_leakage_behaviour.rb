module S2
  module Messages
    module MessageType
      FRBCLeakageBehaviour = "FRBC.LeakageBehaviour"
    end


    class FRBCLeakageBehaviourElement < Dry::Struct

      # The fill level range for which this FRBC.LeakageBehaviourElement applies. The start of
      # the range must be less than the end of the range.
      attribute :fill_level_range, Schemas::NumberRange

      # Indicates how fast the momentary fill level will decrease per second due to leakage
      # within the given range of the fill level. A positive value indicates that the fill level
      # decreases over time due to leakage.
      attribute :leakage_rate, Types::Double

      def self.from_dynamic!(d)
        d = Types::Hash[d]
        new(
          fill_level_range: NumberRange.from_dynamic!(d.fetch("fill_level_range")),
          leakage_rate:     d.fetch("leakage_rate"),
        )
      end

      def self.from_json!(json)
        from_dynamic!(JSON.parse(json))
      end

      def to_dynamic
        {
          "fill_level_range" => fill_level_range.to_dynamic,
          "leakage_rate"     => leakage_rate,
        }
      end

      def to_json(options = nil)
        JSON.generate(to_dynamic, options)
      end
    end

    module MessageType
      FRBCLeakageBehaviour = "FRBC.LeakageBehaviour"
    end

    class FrbcLeakageBehaviour < Dry::Struct

      # List of elements that model the leakage behaviour of the buffer. The fill_level_ranges of
      # the elements must be contiguous.
      attribute :elements, Types.Array(FRBCLeakageBehaviourElement)

      # ID of this message
      attribute :message_id, Types::String

      attribute :message_type, Types::MessageType

      # Moment this FRBC.LeakageBehaviour starts to be valid. If the FRBC.LeakageBehaviour is
      # immediately valid, the DateTimeStamp should be now or in the past.
      attribute :valid_from, Types::String

      def self.from_dynamic!(d)
        d = Types::Hash[d]
        new(
          elements:     d.fetch("elements").map { |x| FRBCLeakageBehaviourElement.from_dynamic!(x) },
          message_id:   d.fetch("message_id"),
          message_type: d.fetch("message_type"),
          valid_from:   d.fetch("valid_from"),
        )
      end

      def self.from_json!(json)
        from_dynamic!(JSON.parse(json))
      end

      def to_dynamic
        {
          "elements"     => elements.map { |x| x.to_dynamic },
          "message_id"   => message_id,
          "message_type" => message_type,
          "valid_from"   => valid_from,
        }
      end

      def to_json(options = nil)
        JSON.generate(to_dynamic, options)
      end
    end
  end
end
