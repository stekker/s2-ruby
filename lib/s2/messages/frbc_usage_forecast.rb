module S2
  module Messages
    module MessageType
      FRBCUsageForecast = "FRBC.UsageForecast"
    end

    class FRBCUsageForecastElement < Dry::Struct

      # Indicator for how long the given usage_rate is valid.
      attribute :duration, Types::Integer

      # The most likely value for the usage rate; the expected increase or decrease of the
      # fill_level per second. A positive value indicates that the fill level will decrease due
      # to usage.
      attribute :usage_rate_expected, Types::Double

      # The lower limit of the range with a 68 % probability that the usage rate is within that
      # range. A positive value indicates that the fill level will decrease due to usage.
      attribute :usage_rate_lower_68_ppr, Types::Double.optional

      # The lower limit of the range with a 95 % probability that the usage rate is within that
      # range. A positive value indicates that the fill level will decrease due to usage.
      attribute :usage_rate_lower_95_ppr, Types::Double.optional

      # The lower limit of the range with a 100 % probability that the usage rate is within that
      # range. A positive value indicates that the fill level will decrease due to usage.
      attribute :usage_rate_lower_limit, Types::Double.optional

      # The upper limit of the range with a 68 % probability that the usage rate is within that
      # range. A positive value indicates that the fill level will decrease due to usage.
      attribute :usage_rate_upper_68_ppr, Types::Double.optional

      # The upper limit of the range with a 95 % probability that the usage rate is within that
      # range. A positive value indicates that the fill level will decrease due to usage.
      attribute :usage_rate_upper_95_ppr, Types::Double.optional

      # The upper limit of the range with a 100 % probability that the usage rate is within that
      # range. A positive value indicates that the fill level will decrease due to usage.
      attribute :usage_rate_upper_limit, Types::Double.optional

      def self.from_dynamic!(d)
        d = Types::Hash[d]
        new(
          duration:                d.fetch("duration"),
          usage_rate_expected:     d.fetch("usage_rate_expected"),
          usage_rate_lower_68_ppr: d["usage_rate_lower_68PPR"],
          usage_rate_lower_95_ppr: d["usage_rate_lower_95PPR"],
          usage_rate_lower_limit:  d["usage_rate_lower_limit"],
          usage_rate_upper_68_ppr: d["usage_rate_upper_68PPR"],
          usage_rate_upper_95_ppr: d["usage_rate_upper_95PPR"],
          usage_rate_upper_limit:  d["usage_rate_upper_limit"],
        )
      end

      def self.from_json!(json)
        from_dynamic!(JSON.parse(json))
      end

      def to_dynamic
        {
          "duration"               => duration,
          "usage_rate_expected"    => usage_rate_expected,
          "usage_rate_lower_68PPR" => usage_rate_lower_68_ppr,
          "usage_rate_lower_95PPR" => usage_rate_lower_95_ppr,
          "usage_rate_lower_limit" => usage_rate_lower_limit,
          "usage_rate_upper_68PPR" => usage_rate_upper_68_ppr,
          "usage_rate_upper_95PPR" => usage_rate_upper_95_ppr,
          "usage_rate_upper_limit" => usage_rate_upper_limit,
        }
      end

      def to_json(options = nil)
        JSON.generate(to_dynamic, options)
      end
    end

    module MessageType
      FRBCUsageForecast = "FRBC.UsageForecast"
    end

    class FrbcUsageForecast < Dry::Struct

      # Further elements that model the profile. There shall be at least one element. Elements
      # must be placed in chronological order.
      attribute :elements, Types.Array(FRBCUsageForecastElement)

      # ID of this message
      attribute :message_id, Types::String

      attribute :message_type, Types::MessageType

      # Time at which the FRBC.UsageForecast starts.
      attribute :start_time, Types::String

      def self.from_dynamic!(d)
        d = Types::Hash[d]
        new(
          elements:     d.fetch("elements").map { |x| FRBCUsageForecastElement.from_dynamic!(x) },
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
