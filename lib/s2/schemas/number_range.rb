module S2
  module Schemas

    # The fill level range for which this FRBC.LeakageBehaviourElement applies. The start of
    # the range must be less than the end of the range.
    class NumberRange < Dry::Struct

      # Number that defines the end of the range
      attribute :end_of_range, S2::Messages::Types::Double

      # Number that defines the start of the range
      attribute :start_of_range, S2::Messages::Types::Double

      def self.from_dynamic!(d)
        d = S2::Messages::Types::Hash[d]
        new(
          end_of_range: d.fetch("end_of_range"),
          start_of_range: d.fetch("start_of_range"),
        )
      end

      def self.from_json!(json)
        from_dynamic!(JSON.parse(json))
      end

      def to_dynamic
        {
          "end_of_range" => end_of_range,
          "start_of_range" => start_of_range,
        }
      end

      def to_json(options = nil)
        JSON.generate(to_dynamic, options)
      end
    end
  end
end
