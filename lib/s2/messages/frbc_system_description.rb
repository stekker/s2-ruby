module S2
  module Messages
    module MessageType
      FRBCSystemDescription = "FRBC.SystemDescription"
    end

    module Types
      MessageType       = Strict::String.enum("FRBC.SystemDescription")
    end

    # The range of the fill level for which this FRBC.OperationModeElement applies. The start
    # of the NumberRange shall be smaller than the end of the NumberRange.
    #
    # Indicates the change in fill_level per second. The lower_boundary of the NumberRange is
    # associated with an operation_mode_factor of 0, the upper_boundary is associated with an
    # operation_mode_factor of 1.
    #
    # Additional costs per second (e.g. wear, services) associated with this operation mode in
    # the currency defined by the ResourceManagerDetails, excluding the commodity cost. The
    # range is expressing uncertainty and is not linked to the operation_mode_factor.
    #
    # The range in which the fill_level should remain. It is expected of the CEM to keep the
    # fill_level within this range. When the fill_level is not within this range, the Resource
    # Manager can ignore instructions from the CEM (except during abnormal conditions).
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

    # The power quantity the values refer to
    #
    # ELECTRIC.POWER.L1: Electric power described in Watt on phase 1. If a device utilizes only
    # one phase it should always use L1.
    # ELECTRIC.POWER.L2: Electric power described in Watt on phase 2. Only applicable for 3
    # phase devices.
    # ELECTRIC.POWER.L3: Electric power described in Watt on phase 3. Only applicable for 3
    # phase devices.
    # ELECTRIC.POWER.3_PHASE_SYMMETRIC: Electric power described in Watt on when power is
    # equally shared among the three phases. Only applicable for 3 phase devices.
    # NATURAL_GAS.FLOW_RATE: Gas flow rate described in liters per second
    # HYDROGEN.FLOW_RATE: Gas flow rate described in grams per second
    # HEAT.TEMPERATURE: Heat described in degrees Celsius
    # HEAT.FLOW_RATE: Flow rate of heat carrying gas or liquid in liters per second
    # HEAT.THERMAL_POWER: Thermal power in Watt
    # OIL.FLOW_RATE: Oil flow rate described in liters per hour
    module CommodityQuantity
      ElectricPower3_PhaseSymmetric = "ELECTRIC.POWER.3_PHASE_SYMMETRIC"
      ElectricPowerL1               = "ELECTRIC.POWER.L1"
      ElectricPowerL2               = "ELECTRIC.POWER.L2"
      ElectricPowerL3               = "ELECTRIC.POWER.L3"
      HeatFlowRate                  = "HEAT.FLOW_RATE"
      HeatTemperature               = "HEAT.TEMPERATURE"
      HeatThermalPower              = "HEAT.THERMAL_POWER"
      HydrogenFlowRate              = "HYDROGEN.FLOW_RATE"
      NaturalGasFlowRate            = "NATURAL_GAS.FLOW_RATE"
      OilFlowRate                   = "OIL.FLOW_RATE"
    end

    class PowerRange < Dry::Struct

      # The power quantity the values refer to
      attribute :commodity_quantity, Types::CommodityQuantity

      # Power value that defines the end of the range.
      attribute :end_of_range, Types::Double

      # Power value that defines the start of the range.
      attribute :start_of_range, Types::Double

      def self.from_dynamic!(d)
        d = Types::Hash[d]
        new(
          commodity_quantity: d.fetch("commodity_quantity"),
          end_of_range:       d.fetch("end_of_range"),
          start_of_range:     d.fetch("start_of_range"),
        )
      end

      def self.from_json!(json)
        from_dynamic!(JSON.parse(json))
      end

      def to_dynamic
        {
          "commodity_quantity" => commodity_quantity,
          "end_of_range"       => end_of_range,
          "start_of_range"     => start_of_range,
        }
      end

      def to_json(options = nil)
        JSON.generate(to_dynamic, options)
      end
    end

    class FRBCOperationModeElement < Dry::Struct

      # The range of the fill level for which this FRBC.OperationModeElement applies. The start
      # of the NumberRange shall be smaller than the end of the NumberRange.
      attribute :fill_level_range, NumberRange

      # Indicates the change in fill_level per second. The lower_boundary of the NumberRange is
      # associated with an operation_mode_factor of 0, the upper_boundary is associated with an
      # operation_mode_factor of 1.
      attribute :fill_rate, NumberRange

      # The power produced or consumed by this operation mode. The start of each PowerRange is
      # associated with an operation_mode_factor of 0, the end is associated with an
      # operation_mode_factor of 1. In the array there must be at least one PowerRange, and at
      # most one PowerRange per CommodityQuantity.
      attribute :power_ranges, Types.Array(PowerRange)

      # Additional costs per second (e.g. wear, services) associated with this operation mode in
      # the currency defined by the ResourceManagerDetails, excluding the commodity cost. The
      # range is expressing uncertainty and is not linked to the operation_mode_factor.
      attribute :running_costs, NumberRange.optional

      def self.from_dynamic!(d)
        d = Types::Hash[d]
        new(
          fill_level_range: NumberRange.from_dynamic!(d.fetch("fill_level_range")),
          fill_rate:        NumberRange.from_dynamic!(d.fetch("fill_rate")),
          power_ranges:     d.fetch("power_ranges").map { |x| PowerRange.from_dynamic!(x) },
          running_costs:    d["running_costs"] ? NumberRange.from_dynamic!(d["running_costs"]) : nil,
        )
      end

      def self.from_json!(json)
        from_dynamic!(JSON.parse(json))
      end

      def to_dynamic
        {
          "fill_level_range" => fill_level_range.to_dynamic,
          "fill_rate"        => fill_rate.to_dynamic,
          "power_ranges"     => power_ranges.map { |x| x.to_dynamic },
          "running_costs"    => running_costs&.to_dynamic,
        }
      end

      def to_json(options = nil)
        JSON.generate(to_dynamic, options)
      end
    end

    class FRBCOperationMode < Dry::Struct

      # Indicates if this FRBC.OperationMode may only be used during an abnormal condition
      attribute :abnormal_condition_only, Types::Bool

      # Human readable name/description of the FRBC.OperationMode. This element is only intended
      # for diagnostic purposes and not for HMI applications.
      attribute :diagnostic_label, Types::String.optional

      # List of FRBC.OperationModeElements, which describe the properties of this
      # FRBC.OperationMode depending on the fill_level. The fill_level_ranges of the items in the
      # Array must be contiguous.
      attribute :elements, Types.Array(FRBCOperationModeElement)

      # ID of the FRBC.OperationMode. Must be unique in the scope of the FRBC.ActuatorDescription
      # in which it is used.
      attribute :id, Types::String

      def self.from_dynamic!(d)
        d = Types::Hash[d]
        new(
          abnormal_condition_only: d.fetch("abnormal_condition_only"),
          diagnostic_label:        d["diagnostic_label"],
          elements:                d.fetch("elements").map { |x| FRBCOperationModeElement.from_dynamic!(x) },
          id:                      d.fetch("id"),
        )
      end

      def self.from_json!(json)
        from_dynamic!(JSON.parse(json))
      end

      def to_dynamic
        {
          "abnormal_condition_only" => abnormal_condition_only,
          "diagnostic_label"        => diagnostic_label,
          "elements"                => elements.map { |x| x.to_dynamic },
          "id"                      => id,
        }
      end

      def to_json(options = nil)
        JSON.generate(to_dynamic, options)
      end
    end

    # GAS: Identifier for Commodity GAS
    # HEAT: Identifier for Commodity HEAT
    # ELECTRICITY: Identifier for Commodity ELECTRICITY
    # OIL: Identifier for Commodity OIL
    module Commodity
      Electricity = "ELECTRICITY"
      Gas         = "GAS"
      Heat        = "HEAT"
      Oil         = "OIL"
    end

    class Timer < Dry::Struct

      # Human readable name/description of the Timer. This element is only intended for
      # diagnostic purposes and not for HMI applications.
      attribute :diagnostic_label, Types::String.optional

      # The time it takes for the Timer to finish after it has been started
      attribute :duration, Types::Integer

      # ID of the Timer. Must be unique in the scope of the OMBC.SystemDescription,
      # FRBC.ActuatorDescription or DDBC.ActuatorDescription in which it is used.
      attribute :id, Types::String

      def self.from_dynamic!(d)
        d = Types::Hash[d]
        new(
          diagnostic_label: d["diagnostic_label"],
          duration:         d.fetch("duration"),
          id:               d.fetch("id"),
        )
      end

      def self.from_json!(json)
        from_dynamic!(JSON.parse(json))
      end

      def to_dynamic
        {
          "diagnostic_label" => diagnostic_label,
          "duration"         => duration,
          "id"               => id,
        }
      end

      def to_json(options = nil)
        JSON.generate(to_dynamic, options)
      end
    end

    class Transition < Dry::Struct

      # Indicates if this Transition may only be used during an abnormal condition (see Clause )
      attribute :abnormal_condition_only, Types::Bool

      # List of IDs of Timers that block this Transition from initiating while at least one of
      # these Timers is not yet finished
      attribute :blocking_timers, Types.Array(Types::String)

      # ID of the OperationMode (exact type differs per ControlType) that should be switched from.
      attribute :from, Types::String

      # ID of the Transition. Must be unique in the scope of the OMBC.SystemDescription,
      # FRBC.ActuatorDescription or DDBC.ActuatorDescription in which it is used.
      attribute :id, Types::String

      # List of IDs of Timers that will be (re)started when this transition is initiated
      attribute :start_timers, Types.Array(Types::String)

      # ID of the OperationMode (exact type differs per ControlType) that will be switched to.
      attribute :to, Types::String

      # Absolute costs for going through this Transition in the currency as described in the
      # ResourceManagerDetails.
      attribute :transition_costs, Types::Double.optional

      # Indicates the time between the initiation of this Transition, and the time at which the
      # device behaves according to the Operation Mode which is defined in the ‘to’ data element.
      # When no value is provided it is assumed the transition duration is negligible.
      attribute :transition_duration, Types::Integer.optional

      def self.from_dynamic!(d)
        d = Types::Hash[d]
        new(
          abnormal_condition_only: d.fetch("abnormal_condition_only"),
          blocking_timers:         d.fetch("blocking_timers"),
          from:                    d.fetch("from"),
          id:                      d.fetch("id"),
          start_timers:            d.fetch("start_timers"),
          to:                      d.fetch("to"),
          transition_costs:        d["transition_costs"],
          transition_duration:     d["transition_duration"],
        )
      end

      def self.from_json!(json)
        from_dynamic!(JSON.parse(json))
      end

      def to_dynamic
        {
          "abnormal_condition_only" => abnormal_condition_only,
          "blocking_timers"         => blocking_timers,
          "from"                    => from,
          "id"                      => id,
          "start_timers"            => start_timers,
          "to"                      => to,
          "transition_costs"        => transition_costs,
          "transition_duration"     => transition_duration,
        }
      end

      def to_json(options = nil)
        JSON.generate(to_dynamic, options)
      end
    end

    class FRBCActuatorDescription < Dry::Struct

      # Human readable name/description for the actuator. This element is only intended for
      # diagnostic purposes and not for HMI applications.
      attribute :diagnostic_label, Types::String.optional

      # ID of the Actuator. Must be unique in the scope of the Resource Manager, for at least the
      # duration of the session between Resource Manager and CEM.
      attribute :id, Types::String

      # Provided FRBC.OperationModes associated with this actuator
      attribute :operation_modes, Types.Array(FRBCOperationMode)

      # List of all supported Commodities.
      attribute :supported_commodities, Types.Array(Types::Commodity)

      # List of Timers associated with this actuator
      attribute :timers, Types.Array(Timer)

      # Possible transitions between FRBC.OperationModes associated with this actuator.
      attribute :transitions, Types.Array(Transition)

      def self.from_dynamic!(d)
        d = Types::Hash[d]
        new(
          diagnostic_label:      d["diagnostic_label"],
          id:                    d.fetch("id"),
          operation_modes:       d.fetch("operation_modes").map { |x| FRBCOperationMode.from_dynamic!(x) },
          supported_commodities: d.fetch("supported_commodities"),
          timers:                d.fetch("timers").map { |x| Timer.from_dynamic!(x) },
          transitions:           d.fetch("transitions").map { |x| Transition.from_dynamic!(x) },
        )
      end

      def self.from_json!(json)
        from_dynamic!(JSON.parse(json))
      end

      def to_dynamic
        {
          "diagnostic_label"      => diagnostic_label,
          "id"                    => id,
          "operation_modes"       => operation_modes.map { |x| x.to_dynamic },
          "supported_commodities" => supported_commodities,
          "timers"                => timers.map { |x| x.to_dynamic },
          "transitions"           => transitions.map { |x| x.to_dynamic },
        }
      end

      def to_json(options = nil)
        JSON.generate(to_dynamic, options)
      end
    end

    # Details of the storage.
    class FRBCStorageDescription < Dry::Struct

      # Human readable name/description of the storage (e.g. hot water buffer or battery). This
      # element is only intended for diagnostic purposes and not for HMI applications.
      attribute :diagnostic_label, Types::String.optional

      # Human readable description of the (physical) units associated with the fill_level (e.g.
      # degrees Celsius or percentage state of charge). This element is only intended for
      # diagnostic purposes and not for HMI applications.
      attribute :fill_level_label, Types::String.optional

      # The range in which the fill_level should remain. It is expected of the CEM to keep the
      # fill_level within this range. When the fill_level is not within this range, the Resource
      # Manager can ignore instructions from the CEM (except during abnormal conditions).
      attribute :fill_level_range, NumberRange

      # Indicates whether the Storage could provide a target profile for the fill level through
      # the FRBC.FillLevelTargetProfile.
      attribute :provides_fill_level_target_profile, Types::Bool

      # Indicates whether the Storage could provide details of power leakage behaviour through
      # the FRBC.LeakageBehaviour.
      attribute :provides_leakage_behaviour, Types::Bool

      # Indicates whether the Storage could provide a UsageForecast through the
      # FRBC.UsageForecast.
      attribute :provides_usage_forecast, Types::Bool

      def self.from_dynamic!(d)
        d = Types::Hash[d]
        new(
          diagnostic_label:                   d["diagnostic_label"],
          fill_level_label:                   d["fill_level_label"],
          fill_level_range:                   NumberRange.from_dynamic!(d.fetch("fill_level_range")),
          provides_fill_level_target_profile: d.fetch("provides_fill_level_target_profile"),
          provides_leakage_behaviour:         d.fetch("provides_leakage_behaviour"),
          provides_usage_forecast:            d.fetch("provides_usage_forecast"),
        )
      end

      def self.from_json!(json)
        from_dynamic!(JSON.parse(json))
      end

      def to_dynamic
        {
          "diagnostic_label"                   => diagnostic_label,
          "fill_level_label"                   => fill_level_label,
          "fill_level_range"                   => fill_level_range.to_dynamic,
          "provides_fill_level_target_profile" => provides_fill_level_target_profile,
          "provides_leakage_behaviour"         => provides_leakage_behaviour,
          "provides_usage_forecast"            => provides_usage_forecast,
        }
      end

      def to_json(options = nil)
        JSON.generate(to_dynamic, options)
      end
    end

    class FrbcSystemDescription < Dry::Struct

      # Details of all Actuators.
      attribute :actuators, Types.Array(FRBCActuatorDescription)

      # ID of this message
      attribute :message_id, Types::String

      attribute :message_type, Types::MessageType

      # Details of the storage.
      attribute :storage, FRBCStorageDescription

      # Moment this FRBC.SystemDescription starts to be valid. If the system description is
      # immediately valid, the DateTimeStamp should be now or in the past.
      attribute :valid_from, Types::String

      def self.from_dynamic!(d)
        d = Types::Hash[d]
        new(
          actuators:    d.fetch("actuators").map { |x| FRBCActuatorDescription.from_dynamic!(x) },
          message_id:   d.fetch("message_id"),
          message_type: d.fetch("message_type"),
          storage:      FRBCStorageDescription.from_dynamic!(d.fetch("storage")),
          valid_from:   d.fetch("valid_from"),
        )
      end

      def self.from_json!(json)
        from_dynamic!(JSON.parse(json))
      end

      def to_dynamic
        {
          "actuators"    => actuators.map { |x| x.to_dynamic },
          "message_id"   => message_id,
          "message_type" => message_type,
          "storage"      => storage.to_dynamic,
          "valid_from"   => valid_from,
        }
      end

      def to_json(options = nil)
        JSON.generate(to_dynamic, options)
      end
    end
  end
end
