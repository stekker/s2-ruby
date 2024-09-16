module S2
  module Messages
    module MessageType
      FRBCFillLevelTargetProfile = "FRBC.FillLevelTargetProfile"
    end

    # The target range in which the fill_level must be for the time period during which the
    # element is active. The start of the range must be smaller or equal to the end of the
    # range. The CEM must take best-effort actions to proactively achieve this target.
    class NumberRange < Dry::Struct

      # Number that defines the end of the range
      attribute :end_of_range, Types::Double

      # Number that defines the start of the range
      attribute :start_of_range, Types::Double

      def self.from_dynamic!(d)
        d = Types::Hash[d]
        new(
          end_of_range:   d.fetch("end_of_range"),
          start_of_range: d.fetch("start_of_range"),
        )
      end

      def self.from_json!(json)
        from_dynamic!(JSON.parse(json))
      end

      def to_dynamic
        {
          "end_of_range"   => end_of_range,
          "start_of_range" => start_of_range,
        }
      end

      def to_json(options = nil)
        JSON.generate(to_dynamic, options)
      end
    end

    class FRBCFillLevelTargetProfileElement < Dry::Struct

      # The duration of the element.
      attribute :duration, Types::Integer

      # The target range in which the fill_level must be for the time period during which the
      # element is active. The start of the range must be smaller or equal to the end of the
      # range. The CEM must take best-effort actions to proactively achieve this target.
      attribute :fill_level_range, NumberRange

      def self.from_dynamic!(d)
        d = Types::Hash[d]
        new(
          duration:         d.fetch("duration"),
          fill_level_range: NumberRange.from_dynamic!(d.fetch("fill_level_range")),
        )
      end

      def self.from_json!(json)
        from_dynamic!(JSON.parse(json))
      end

      def to_dynamic
        {
          "duration"         => duration,
          "fill_level_range" => fill_level_range.to_dynamic,
        }
      end

      def to_json(options = nil)
        JSON.generate(to_dynamic, options)
      end
    end

    module MessageType
      FRBCFillLevelTargetProfile = "FRBC.FillLevelTargetProfile"
    end

    class FrbcFillLevelTargetProfile < Dry::Struct

      # List of different fill levels that have to be targeted within a given duration. There
      # shall be at least one element. Elements must be placed in chronological order.
      attribute :elements, Types.Array(FRBCFillLevelTargetProfileElement)

      # ID of this message
      attribute :message_id, Types::String

      attribute :message_type, Types::MessageType

      # Time at which the FRBC.FillLevelTargetProfile starts.
      attribute :start_time, Types::String

      def self.from_dynamic!(d)
        d = Types::Hash[d]
        new(
          elements:     d.fetch("elements").map { |x| FRBCFillLevelTargetProfileElement.from_dynamic!(x) },
          message_id:   d.fetch("message_id"),
          message_type: d.fetch("message_type"),
          start_time:   d.fetch("start_time"),
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
          "start_time"   => start_time,
        }
      end

      def to_json(options = nil)
        JSON.generate(to_dynamic, options)
      end
    end
  end
end
