# This code may look unusually verbose for Ruby (and it is), but
# it performs some subtle and complex validation of JSON data.
#
# To parse this JSON, add 'dry-struct' and 'dry-types' gems, then do:
#
#   commodity = Commodity.from_json! "…"
#   puts commodity == Commodity::Electricity
#
#   commodity_quantity = CommodityQuantity.from_json! "…"
#   puts commodity_quantity == CommodityQuantity::ElectricPower3_PhaseSymmetric
#
#   control_type = ControlType.from_json! "…"
#   puts control_type == ControlType::DemandDrivenBasedControl
#
#   currency = Currency.from_json! "…"
#   puts currency == Currency::Aed
#
#   duration = Duration.from_json! "…"
#   puts duration.even?
#
#   energy_management_role = EnergyManagementRole.from_json! "…"
#   puts energy_management_role == EnergyManagementRole::Cem
#
#   frbc_actuator_description = FRBCActuatorDescription.from_json! "{…}"
#   puts frbc_actuator_description.transitions.first.start_timers.first
#
#   frbc_fill_level_target_profile_element = FRBCFillLevelTargetProfileElement.from_json! "{…}"
#   puts frbc_fill_level_target_profile_element.fill_level_range.end_of_range
#
#   frbc_leakage_behaviour_element = FRBCLeakageBehaviourElement.from_json! "{…}"
#   puts frbc_leakage_behaviour_element.fill_level_range.end_of_range
#
#   frbc_operation_mode = FRBCOperationMode.from_json! "{…}"
#   puts frbc_operation_mode.elements.first.running_costs&.end_of_range
#
#   frbc_operation_mode_element = FRBCOperationModeElement.from_json! "{…}"
#   puts frbc_operation_mode_element.running_costs&.end_of_range
#
#   frbc_storage_description = FRBCStorageDescription.from_json! "{…}"
#   puts frbc_storage_description.fill_level_range.end_of_range
#
#   frbc_usage_forecast_element = FRBCUsageForecastElement.from_json! "{…}"
#   puts frbc_usage_forecast_element.duration.even?
#
#   id = ID.from_json! "…"
#   puts id
#
#   instruction_status = InstructionStatus.from_json! "…"
#   puts instruction_status == InstructionStatus::Aborted
#
#   number_range = NumberRange.from_json! "{…}"
#   puts number_range.end_of_range
#
#   power_forecast_element = PowerForecastElement.from_json! "{…}"
#   puts power_forecast_element.power_values.first.commodity_quantity == CommodityQuantity::ElectricPower3_PhaseSymmetric
#
#   power_forecast_value = PowerForecastValue.from_json! "{…}"
#   puts power_forecast_value.commodity_quantity == CommodityQuantity::ElectricPower3_PhaseSymmetric
#
#   power_range = PowerRange.from_json! "{…}"
#   puts power_range.commodity_quantity == CommodityQuantity::ElectricPower3_PhaseSymmetric
#
#   power_value = PowerValue.from_json! "{…}"
#   puts power_value.commodity_quantity == CommodityQuantity::ElectricPower3_PhaseSymmetric
#
#   reception_status_values = ReceptionStatusValues.from_json! "…"
#   puts reception_status_values == ReceptionStatusValues::InvalidContent
#
#   revokable_objects = RevokableObjects.from_json! "…"
#   puts revokable_objects == RevokableObjects::DDBCInstruction
#
#   role = Role.from_json! "{…}"
#   puts role.commodity == Commodity::Electricity
#
#   role_type = RoleType.from_json! "…"
#   puts role_type == RoleType::EnergyConsumer
#
#   session_request_type = SessionRequestType.from_json! "…"
#   puts session_request_type == SessionRequestType::Reconnect
#
#   timer = Timer.from_json! "{…}"
#   puts timer.diagnostic_label
#
#   transition = Transition.from_json! "{…}"
#   puts transition.start_timers.first
#
#   frbc_actuator_status = FRBCActuatorStatus.from_json! "{…}"
#   puts frbc_actuator_status.active_operation_mode_id
#
#   frbc_fill_level_target_profile = FRBCFillLevelTargetProfile.from_json! "{…}"
#   puts frbc_fill_level_target_profile.elements.first.fill_level_range.end_of_range
#
#   frbc_instruction = FRBCInstruction.from_json! "{…}"
#   puts frbc_instruction.abnormal_condition
#
#   frbc_leakage_behaviour = FRBCLeakageBehaviour.from_json! "{…}"
#   puts frbc_leakage_behaviour.elements.first.fill_level_range.end_of_range
#
#   frbc_storage_status = FRBCStorageStatus.from_json! "{…}"
#   puts frbc_storage_status.message_id
#
#   frbc_system_description = FRBCSystemDescription.from_json! "{…}"
#   puts frbc_system_description.storage.fill_level_range.end_of_range
#
#   frbc_timer_status = FRBCTimerStatus.from_json! "{…}"
#   puts frbc_timer_status.actuator_id
#
#   frbc_usage_forecast = FRBCUsageForecast.from_json! "{…}"
#   puts frbc_usage_forecast.elements.first.duration.even?
#
#   handshake = Handshake.from_json! "{…}"
#   puts handshake.supported_protocol_versions&.first
#
#   handshake_response = HandshakeResponse.from_json! "{…}"
#   puts handshake_response.message_id
#
#   instruction_status_update = InstructionStatusUpdate.from_json! "{…}"
#   puts instruction_status_update.instruction_id
#
#   power_forecast = PowerForecast.from_json! "{…}"
#   puts power_forecast.elements.first.power_values.first.commodity_quantity == CommodityQuantity::ElectricPower3_PhaseSymmetric
#
#   power_measurement = PowerMeasurement.from_json! "{…}"
#   puts power_measurement.values.first.commodity_quantity == CommodityQuantity::ElectricPower3_PhaseSymmetric
#
#   reception_status = ReceptionStatus.from_json! "{…}"
#   puts reception_status.diagnostic_label
#
#   resource_manager_details = ResourceManagerDetails.from_json! "{…}"
#   puts resource_manager_details.roles.first.commodity == Commodity::Electricity
#
#   revoke_object = RevokeObject.from_json! "{…}"
#   puts revoke_object.message_id
#
#   select_control_type = SelectControlType.from_json! "{…}"
#   puts select_control_type.control_type == ControlType::DemandDrivenBasedControl
#
#   session_request = SessionRequest.from_json! "{…}"
#   puts session_request.diagnostic_label
#
# If from_json! succeeds, the value returned matches the schema.

require 'json'
require 'dry-types'
require 'dry-struct'

module S2
  module Messages
    module Types
      include Dry.Types(default: :nominal)

      Integer                               = Strict::Integer
      Bool                                  = Strict::Bool
      Hash                                  = Strict::Hash
      String                                = Strict::String
      Double                                = Strict::Float | Strict::Integer
      CommodityQuantity                     = Strict::String.enum("ELECTRIC.POWER.3_PHASE_SYMMETRIC", "ELECTRIC.POWER.L1", "ELECTRIC.POWER.L2", "ELECTRIC.POWER.L3", "HEAT.FLOW_RATE", "HEAT.TEMPERATURE", "HEAT.THERMAL_POWER", "HYDROGEN.FLOW_RATE", "NATURAL_GAS.FLOW_RATE", "OIL.FLOW_RATE")
      Commodity                             = Strict::String.enum("ELECTRICITY", "GAS", "HEAT", "OIL")
      RoleType                              = Strict::String.enum("ENERGY_CONSUMER", "ENERGY_PRODUCER", "ENERGY_STORAGE")
      FRBCActuatorStatusMessageType         = Strict::String.enum("FRBC.ActuatorStatus")
      FRBCFillLevelTargetProfileMessageType = Strict::String.enum("FRBC.FillLevelTargetProfile")
      FRBCInstructionMessageType            = Strict::String.enum("FRBC.Instruction")
      FRBCLeakageBehaviourMessageType       = Strict::String.enum("FRBC.LeakageBehaviour")
      FRBCStorageStatusMessageType          = Strict::String.enum("FRBC.StorageStatus")
      FRBCSystemDescriptionMessageType      = Strict::String.enum("FRBC.SystemDescription")
      FRBCTimerStatusMessageType            = Strict::String.enum("FRBC.TimerStatus")
      FRBCUsageForecastMessageType          = Strict::String.enum("FRBC.UsageForecast")
      HandshakeMessageType                  = Strict::String.enum("Handshake")
      EnergyManagementRole                  = Strict::String.enum("CEM", "RM")
      HandshakeResponseMessageType          = Strict::String.enum("HandshakeResponse")
      InstructionStatusUpdateMessageType    = Strict::String.enum("InstructionStatusUpdate")
      InstructionStatus                     = Strict::String.enum("ABORTED", "ACCEPTED", "NEW", "REJECTED", "REVOKED", "STARTED", "SUCCEEDED")
      PowerForecastMessageType              = Strict::String.enum("PowerForecast")
      PowerMeasurementMessageType           = Strict::String.enum("PowerMeasurement")
      ReceptionStatusMessageType            = Strict::String.enum("ReceptionStatus")
      ReceptionStatusValues                 = Strict::String.enum("INVALID_CONTENT", "INVALID_DATA", "INVALID_MESSAGE", "OK", "PERMANENT_ERROR", "TEMPORARY_ERROR")
      ControlType                           = Strict::String.enum("DEMAND_DRIVEN_BASED_CONTROL", "FILL_RATE_BASED_CONTROL", "NO_SELECTION", "NOT_CONTROLABLE", "OPERATION_MODE_BASED_CONTROL", "POWER_ENVELOPE_BASED_CONTROL", "POWER_PROFILE_BASED_CONTROL")
      Currency                              = Strict::String.enum("AED", "ANG", "AUD", "CHE", "CHF", "CHW", "EUR", "GBP", "LBP", "LKR", "LRD", "LSL", "LYD", "MAD", "MDL", "MGA", "MKD", "MMK", "MNT", "MOP", "MRO", "MUR", "MVR", "MWK", "MXN", "MXV", "MYR", "MZN", "NIO", "NAD", "NGN", "NOK", "NPR", "NZD", "OMR", "PHP", "PAB", "PEN", "PGK", "PKR", "PLN", "PYG", "QAR", "RON", "RSD", "RUB", "RWF", "SSP", "SAR", "SBD", "SCR", "SDG", "SEK", "SGD", "SHP", "SLL", "SOS", "SRD", "STD", "SYP", "SZL", "THB", "TJS", "TMT", "TND", "TOP", "TRY", "TTD", "TWD", "TZS", "UAH", "UGX", "USD", "USN", "UYI", "UYU", "UZS", "VEF", "VND", "VUV", "WST", "XAG", "XAU", "XBA", "XBB", "XBC", "XBD", "XCD", "XOF", "XPD", "XPF", "XPT", "XSU", "XTS", "XUA", "XXX", "YER", "ZAR", "ZMW", "ZWL")
      ResourceManagerDetailsMessageType     = Strict::String.enum("ResourceManagerDetails")
      RevokeObjectMessageType               = Strict::String.enum("RevokeObject")
      RevokableObjects                      = Strict::String.enum("DDBC.Instruction", "DDBC.SystemDescription", "FRBC.Instruction", "FRBC.SystemDescription", "OMBC.Instruction", "OMBC.SystemDescription", "PEBC.EnergyConstraint", "PEBC.Instruction", "PEBC.PowerConstraints", "PPBC.EndInterruptionInstruction", "PPBC.PowerProfileDefinition", "PPBC.ScheduleInstruction", "PPBC.StartInterruptionInstruction")
      SelectControlTypeMessageType          = Strict::String.enum("SelectControlType")
      SessionRequestMessageType             = Strict::String.enum("SessionRequest")
      SessionRequestType                    = Strict::String.enum("RECONNECT", "TERMINATE")
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
    # The target range in which the fill_level must be for the time period during which the
    # element is active. The start of the range must be smaller or equal to the end of the
    # range. The CEM must take best-effort actions to proactively achieve this target.
    #
    # The fill level range for which this FRBC.LeakageBehaviourElement applies. The start of
    # the range must be less than the end of the range.
    #
    # The range in which the fill_level should remain. It is expected of the CEM to keep the
    # fill_level within this range. When the fill_level is not within this range, the Resource
    # Manager can ignore instructions from the CEM (except during abnormal conditions).
    class FillLevelRangeClass < Dry::Struct

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
    #
    # The power quantity the values refer to
    #
    # The power quantity the value refers to
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

    class PowerRangeElement < Dry::Struct

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

    class ElementElement < Dry::Struct

      # The range of the fill level for which this FRBC.OperationModeElement applies. The start
      # of the NumberRange shall be smaller than the end of the NumberRange.
      attribute :fill_level_range, FillLevelRangeClass

      # Indicates the change in fill_level per second. The lower_boundary of the NumberRange is
      # associated with an operation_mode_factor of 0, the upper_boundary is associated with an
      # operation_mode_factor of 1.
      attribute :fill_rate, FillLevelRangeClass

      # The power produced or consumed by this operation mode. The start of each PowerRange is
      # associated with an operation_mode_factor of 0, the end is associated with an
      # operation_mode_factor of 1. In the array there must be at least one PowerRange, and at
      # most one PowerRange per CommodityQuantity.
      attribute :power_ranges, Types.Array(PowerRangeElement)

      # Additional costs per second (e.g. wear, services) associated with this operation mode in
      # the currency defined by the ResourceManagerDetails, excluding the commodity cost. The
      # range is expressing uncertainty and is not linked to the operation_mode_factor.
      attribute :running_costs, FillLevelRangeClass.optional

      def self.from_dynamic!(d)
        d = Types::Hash[d]
        new(
          fill_level_range: FillLevelRangeClass.from_dynamic!(d.fetch("fill_level_range")),
          fill_rate:        FillLevelRangeClass.from_dynamic!(d.fetch("fill_rate")),
          power_ranges:     d.fetch("power_ranges").map { |x| PowerRangeElement.from_dynamic!(x) },
          running_costs:    d["running_costs"] ? FillLevelRangeClass.from_dynamic!(d["running_costs"]) : nil,
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

    class OperationModeElement < Dry::Struct

      # Indicates if this FRBC.OperationMode may only be used during an abnormal condition
      attribute :abnormal_condition_only, Types::Bool

      # Human readable name/description of the FRBC.OperationMode. This element is only intended
      # for diagnostic purposes and not for HMI applications.
      attribute :diagnostic_label, Types::String.optional

      # List of FRBC.OperationModeElements, which describe the properties of this
      # FRBC.OperationMode depending on the fill_level. The fill_level_ranges of the items in the
      # Array must be contiguous.
      attribute :elements, Types.Array(ElementElement)

      # ID of the FRBC.OperationMode. Must be unique in the scope of the FRBC.ActuatorDescription
      # in which it is used.
      attribute :id, Types::String

      def self.from_dynamic!(d)
        d = Types::Hash[d]
        new(
          abnormal_condition_only: d.fetch("abnormal_condition_only"),
          diagnostic_label:        d["diagnostic_label"],
          elements:                d.fetch("elements").map { |x| ElementElement.from_dynamic!(x) },
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
    #
    # Commodity the role refers to.
    module Commodity
      Electricity = "ELECTRICITY"
      Gas         = "GAS"
      Heat        = "HEAT"
      Oil         = "OIL"
    end

    class TimerElement < Dry::Struct

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

    class TransitionElement < Dry::Struct

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
      attribute :operation_modes, Types.Array(OperationModeElement)

      # List of all supported Commodities.
      attribute :supported_commodities, Types.Array(Types::Commodity)

      # List of Timers associated with this actuator
      attribute :timers, Types.Array(TimerElement)

      # Possible transitions between FRBC.OperationModes associated with this actuator.
      attribute :transitions, Types.Array(TransitionElement)

      def self.from_dynamic!(d)
        d = Types::Hash[d]
        new(
          diagnostic_label:      d["diagnostic_label"],
          id:                    d.fetch("id"),
          operation_modes:       d.fetch("operation_modes").map { |x| OperationModeElement.from_dynamic!(x) },
          supported_commodities: d.fetch("supported_commodities"),
          timers:                d.fetch("timers").map { |x| TimerElement.from_dynamic!(x) },
          transitions:           d.fetch("transitions").map { |x| TransitionElement.from_dynamic!(x) },
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

    class FRBCFillLevelTargetProfileElement < Dry::Struct

      # The duration of the element.
      attribute :duration, Types::Integer

      # The target range in which the fill_level must be for the time period during which the
      # element is active. The start of the range must be smaller or equal to the end of the
      # range. The CEM must take best-effort actions to proactively achieve this target.
      attribute :fill_level_range, FillLevelRangeClass

      def self.from_dynamic!(d)
        d = Types::Hash[d]
        new(
          duration:         d.fetch("duration"),
          fill_level_range: FillLevelRangeClass.from_dynamic!(d.fetch("fill_level_range")),
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

    class FRBCLeakageBehaviourElement < Dry::Struct

      # The fill level range for which this FRBC.LeakageBehaviourElement applies. The start of
      # the range must be less than the end of the range.
      attribute :fill_level_range, FillLevelRangeClass

      # Indicates how fast the momentary fill level will decrease per second due to leakage
      # within the given range of the fill level. A positive value indicates that the fill level
      # decreases over time due to leakage.
      attribute :leakage_rate, Types::Double

      def self.from_dynamic!(d)
        d = Types::Hash[d]
        new(
          fill_level_range: FillLevelRangeClass.from_dynamic!(d.fetch("fill_level_range")),
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

    class FRBCOperationMode < Dry::Struct

      # Indicates if this FRBC.OperationMode may only be used during an abnormal condition
      attribute :abnormal_condition_only, Types::Bool

      # Human readable name/description of the FRBC.OperationMode. This element is only intended
      # for diagnostic purposes and not for HMI applications.
      attribute :diagnostic_label, Types::String.optional

      # List of FRBC.OperationModeElements, which describe the properties of this
      # FRBC.OperationMode depending on the fill_level. The fill_level_ranges of the items in the
      # Array must be contiguous.
      attribute :elements, Types.Array(ElementElement)

      # ID of the FRBC.OperationMode. Must be unique in the scope of the FRBC.ActuatorDescription
      # in which it is used.
      attribute :id, Types::String

      def self.from_dynamic!(d)
        d = Types::Hash[d]
        new(
          abnormal_condition_only: d.fetch("abnormal_condition_only"),
          diagnostic_label:        d["diagnostic_label"],
          elements:                d.fetch("elements").map { |x| ElementElement.from_dynamic!(x) },
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

    class FRBCOperationModeElement < Dry::Struct

      # The range of the fill level for which this FRBC.OperationModeElement applies. The start
      # of the NumberRange shall be smaller than the end of the NumberRange.
      attribute :fill_level_range, FillLevelRangeClass

      # Indicates the change in fill_level per second. The lower_boundary of the NumberRange is
      # associated with an operation_mode_factor of 0, the upper_boundary is associated with an
      # operation_mode_factor of 1.
      attribute :fill_rate, FillLevelRangeClass

      # The power produced or consumed by this operation mode. The start of each PowerRange is
      # associated with an operation_mode_factor of 0, the end is associated with an
      # operation_mode_factor of 1. In the array there must be at least one PowerRange, and at
      # most one PowerRange per CommodityQuantity.
      attribute :power_ranges, Types.Array(PowerRangeElement)

      # Additional costs per second (e.g. wear, services) associated with this operation mode in
      # the currency defined by the ResourceManagerDetails, excluding the commodity cost. The
      # range is expressing uncertainty and is not linked to the operation_mode_factor.
      attribute :running_costs, FillLevelRangeClass.optional

      def self.from_dynamic!(d)
        d = Types::Hash[d]
        new(
          fill_level_range: FillLevelRangeClass.from_dynamic!(d.fetch("fill_level_range")),
          fill_rate:        FillLevelRangeClass.from_dynamic!(d.fetch("fill_rate")),
          power_ranges:     d.fetch("power_ranges").map { |x| PowerRangeElement.from_dynamic!(x) },
          running_costs:    d["running_costs"] ? FillLevelRangeClass.from_dynamic!(d["running_costs"]) : nil,
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
      attribute :fill_level_range, FillLevelRangeClass

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
          fill_level_range:                   FillLevelRangeClass.from_dynamic!(d.fetch("fill_level_range")),
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

    class PowerValueElement < Dry::Struct

      # The power quantity the value refers to
      attribute :commodity_quantity, Types::CommodityQuantity

      # The expected power value.
      attribute :value_expected, Types::Double

      # The lower boundary of the range with 68 % certainty the power value is in it
      attribute :value_lower_68_ppr, Types::Double.optional

      # The lower boundary of the range with 95 % certainty the power value is in it
      attribute :value_lower_95_ppr, Types::Double.optional

      # The lower boundary of the range with 100 % certainty the power value is in it
      attribute :value_lower_limit, Types::Double.optional

      # The upper boundary of the range with 68 % certainty the power value is in it
      attribute :value_upper_68_ppr, Types::Double.optional

      # The upper boundary of the range with 95 % certainty the power value is in it
      attribute :value_upper_95_ppr, Types::Double.optional

      # The upper boundary of the range with 100 % certainty the power value is in it
      attribute :value_upper_limit, Types::Double.optional

      def self.from_dynamic!(d)
        d = Types::Hash[d]
        new(
          commodity_quantity: d.fetch("commodity_quantity"),
          value_expected:     d.fetch("value_expected"),
          value_lower_68_ppr: d["value_lower_68PPR"],
          value_lower_95_ppr: d["value_lower_95PPR"],
          value_lower_limit:  d["value_lower_limit"],
          value_upper_68_ppr: d["value_upper_68PPR"],
          value_upper_95_ppr: d["value_upper_95PPR"],
          value_upper_limit:  d["value_upper_limit"],
        )
      end

      def self.from_json!(json)
        from_dynamic!(JSON.parse(json))
      end

      def to_dynamic
        {
          "commodity_quantity" => commodity_quantity,
          "value_expected"     => value_expected,
          "value_lower_68PPR"  => value_lower_68_ppr,
          "value_lower_95PPR"  => value_lower_95_ppr,
          "value_lower_limit"  => value_lower_limit,
          "value_upper_68PPR"  => value_upper_68_ppr,
          "value_upper_95PPR"  => value_upper_95_ppr,
          "value_upper_limit"  => value_upper_limit,
        }
      end

      def to_json(options = nil)
        JSON.generate(to_dynamic, options)
      end
    end

    class PowerForecastElement < Dry::Struct

      # Duration of the PowerForecastElement
      attribute :duration, Types::Integer

      # The values of power that are expected for the given period of time. There shall be at
      # least one PowerForecastValue, and at most one PowerForecastValue per CommodityQuantity.
      attribute :power_values, Types.Array(PowerValueElement)

      def self.from_dynamic!(d)
        d = Types::Hash[d]
        new(
          duration:     d.fetch("duration"),
          power_values: d.fetch("power_values").map { |x| PowerValueElement.from_dynamic!(x) },
        )
      end

      def self.from_json!(json)
        from_dynamic!(JSON.parse(json))
      end

      def to_dynamic
        {
          "duration"     => duration,
          "power_values" => power_values.map { |x| x.to_dynamic },
        }
      end

      def to_json(options = nil)
        JSON.generate(to_dynamic, options)
      end
    end

    class PowerForecastValue < Dry::Struct

      # The power quantity the value refers to
      attribute :commodity_quantity, Types::CommodityQuantity

      # The expected power value.
      attribute :value_expected, Types::Double

      # The lower boundary of the range with 68 % certainty the power value is in it
      attribute :value_lower_68_ppr, Types::Double.optional

      # The lower boundary of the range with 95 % certainty the power value is in it
      attribute :value_lower_95_ppr, Types::Double.optional

      # The lower boundary of the range with 100 % certainty the power value is in it
      attribute :value_lower_limit, Types::Double.optional

      # The upper boundary of the range with 68 % certainty the power value is in it
      attribute :value_upper_68_ppr, Types::Double.optional

      # The upper boundary of the range with 95 % certainty the power value is in it
      attribute :value_upper_95_ppr, Types::Double.optional

      # The upper boundary of the range with 100 % certainty the power value is in it
      attribute :value_upper_limit, Types::Double.optional

      def self.from_dynamic!(d)
        d = Types::Hash[d]
        new(
          commodity_quantity: d.fetch("commodity_quantity"),
          value_expected:     d.fetch("value_expected"),
          value_lower_68_ppr: d["value_lower_68PPR"],
          value_lower_95_ppr: d["value_lower_95PPR"],
          value_lower_limit:  d["value_lower_limit"],
          value_upper_68_ppr: d["value_upper_68PPR"],
          value_upper_95_ppr: d["value_upper_95PPR"],
          value_upper_limit:  d["value_upper_limit"],
        )
      end

      def self.from_json!(json)
        from_dynamic!(JSON.parse(json))
      end

      def to_dynamic
        {
          "commodity_quantity" => commodity_quantity,
          "value_expected"     => value_expected,
          "value_lower_68PPR"  => value_lower_68_ppr,
          "value_lower_95PPR"  => value_lower_95_ppr,
          "value_lower_limit"  => value_lower_limit,
          "value_upper_68PPR"  => value_upper_68_ppr,
          "value_upper_95PPR"  => value_upper_95_ppr,
          "value_upper_limit"  => value_upper_limit,
        }
      end

      def to_json(options = nil)
        JSON.generate(to_dynamic, options)
      end
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

    class PowerValue < Dry::Struct

      # The power quantity the value refers to
      attribute :commodity_quantity, Types::CommodityQuantity

      # Power value expressed in the unit associated with the CommodityQuantity
      attribute :value, Types::Double

      def self.from_dynamic!(d)
        d = Types::Hash[d]
        new(
          commodity_quantity: d.fetch("commodity_quantity"),
          value:              d.fetch("value"),
        )
      end

      def self.from_json!(json)
        from_dynamic!(JSON.parse(json))
      end

      def to_dynamic
        {
          "commodity_quantity" => commodity_quantity,
          "value"              => value,
        }
      end

      def to_json(options = nil)
        JSON.generate(to_dynamic, options)
      end
    end

    # Role type of the Resource Manager for the given commodity
    #
    # ENERGY_PRODUCER: Identifier for RoleType Producer
    # ENERGY_CONSUMER: Identifier for RoleType Consumer
    # ENERGY_STORAGE: Identifier for RoleType Storage
    module RoleType
      EnergyConsumer = "ENERGY_CONSUMER"
      EnergyProducer = "ENERGY_PRODUCER"
      EnergyStorage  = "ENERGY_STORAGE"
    end

    class Role < Dry::Struct

      # Commodity the role refers to.
      attribute :commodity, Types::Commodity

      # Role type of the Resource Manager for the given commodity
      attribute :role, Types::RoleType

      def self.from_dynamic!(d)
        d = Types::Hash[d]
        new(
          commodity: d.fetch("commodity"),
          role:      d.fetch("role"),
        )
      end

      def self.from_json!(json)
        from_dynamic!(JSON.parse(json))
      end

      def to_dynamic
        {
          "commodity" => commodity,
          "role"      => role,
        }
      end

      def to_json(options = nil)
        JSON.generate(to_dynamic, options)
      end
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

    module FRBCActuatorStatusMessageType
      FRBCActuatorStatus = "FRBC.ActuatorStatus"
    end

    class FRBCActuatorStatus < Dry::Struct

      # ID of the FRBC.OperationMode that is presently active.
      attribute :active_operation_mode_id, Types::String

      # ID of the actuator this messages refers to
      attribute :actuator_id, Types::String

      # ID of this message
      attribute :message_id, Types::String

      attribute :message_type, Types::FRBCActuatorStatusMessageType

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

    class ElementClass < Dry::Struct

      # The duration of the element.
      attribute :duration, Types::Integer

      # The target range in which the fill_level must be for the time period during which the
      # element is active. The start of the range must be smaller or equal to the end of the
      # range. The CEM must take best-effort actions to proactively achieve this target.
      attribute :fill_level_range, FillLevelRangeClass

      def self.from_dynamic!(d)
        d = Types::Hash[d]
        new(
          duration:         d.fetch("duration"),
          fill_level_range: FillLevelRangeClass.from_dynamic!(d.fetch("fill_level_range")),
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

    module FRBCFillLevelTargetProfileMessageType
      FRBCFillLevelTargetProfile = "FRBC.FillLevelTargetProfile"
    end

    class FRBCFillLevelTargetProfile < Dry::Struct

      # List of different fill levels that have to be targeted within a given duration. There
      # shall be at least one element. Elements must be placed in chronological order.
      attribute :elements, Types.Array(ElementClass)

      # ID of this message
      attribute :message_id, Types::String

      attribute :message_type, Types::FRBCFillLevelTargetProfileMessageType

      # Time at which the FRBC.FillLevelTargetProfile starts.
      attribute :start_time, Types::String

      def self.from_dynamic!(d)
        d = Types::Hash[d]
        new(
          elements:     d.fetch("elements").map { |x| ElementClass.from_dynamic!(x) },
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

    module FRBCInstructionMessageType
      FRBCInstruction = "FRBC.Instruction"
    end

    class FRBCInstruction < Dry::Struct

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

      attribute :message_type, Types::FRBCInstructionMessageType

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

    class FRBCLeakageBehaviourElementClass < Dry::Struct

      # The fill level range for which this FRBC.LeakageBehaviourElement applies. The start of
      # the range must be less than the end of the range.
      attribute :fill_level_range, FillLevelRangeClass

      # Indicates how fast the momentary fill level will decrease per second due to leakage
      # within the given range of the fill level. A positive value indicates that the fill level
      # decreases over time due to leakage.
      attribute :leakage_rate, Types::Double

      def self.from_dynamic!(d)
        d = Types::Hash[d]
        new(
          fill_level_range: FillLevelRangeClass.from_dynamic!(d.fetch("fill_level_range")),
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

    module FRBCLeakageBehaviourMessageType
      FRBCLeakageBehaviour = "FRBC.LeakageBehaviour"
    end

    class FRBCLeakageBehaviour < Dry::Struct

      # List of elements that model the leakage behaviour of the buffer. The fill_level_ranges of
      # the elements must be contiguous.
      attribute :elements, Types.Array(FRBCLeakageBehaviourElementClass)

      # ID of this message
      attribute :message_id, Types::String

      attribute :message_type, Types::FRBCLeakageBehaviourMessageType

      # Moment this FRBC.LeakageBehaviour starts to be valid. If the FRBC.LeakageBehaviour is
      # immediately valid, the DateTimeStamp should be now or in the past.
      attribute :valid_from, Types::String

      def self.from_dynamic!(d)
        d = Types::Hash[d]
        new(
          elements:     d.fetch("elements").map { |x| FRBCLeakageBehaviourElementClass.from_dynamic!(x) },
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

    module FRBCStorageStatusMessageType
      FRBCStorageStatus = "FRBC.StorageStatus"
    end

    class FRBCStorageStatus < Dry::Struct

      # ID of this message
      attribute :message_id, Types::String

      attribute :message_type, Types::FRBCStorageStatusMessageType

      # Present fill level of the Storage
      attribute :present_fill_level, Types::Double

      def self.from_dynamic!(d)
        d = Types::Hash[d]
        new(
          message_id:         d.fetch("message_id"),
          message_type:       d.fetch("message_type"),
          present_fill_level: d.fetch("present_fill_level"),
        )
      end

      def self.from_json!(json)
        from_dynamic!(JSON.parse(json))
      end

      def to_dynamic
        {
          "message_id"         => message_id,
          "message_type"       => message_type,
          "present_fill_level" => present_fill_level,
        }
      end

      def to_json(options = nil)
        JSON.generate(to_dynamic, options)
      end
    end

    class ActuatorElement < Dry::Struct

      # Human readable name/description for the actuator. This element is only intended for
      # diagnostic purposes and not for HMI applications.
      attribute :diagnostic_label, Types::String.optional

      # ID of the Actuator. Must be unique in the scope of the Resource Manager, for at least the
      # duration of the session between Resource Manager and CEM.
      attribute :id, Types::String

      # Provided FRBC.OperationModes associated with this actuator
      attribute :operation_modes, Types.Array(OperationModeElement)

      # List of all supported Commodities.
      attribute :supported_commodities, Types.Array(Types::Commodity)

      # List of Timers associated with this actuator
      attribute :timers, Types.Array(TimerElement)

      # Possible transitions between FRBC.OperationModes associated with this actuator.
      attribute :transitions, Types.Array(TransitionElement)

      def self.from_dynamic!(d)
        d = Types::Hash[d]
        new(
          diagnostic_label:      d["diagnostic_label"],
          id:                    d.fetch("id"),
          operation_modes:       d.fetch("operation_modes").map { |x| OperationModeElement.from_dynamic!(x) },
          supported_commodities: d.fetch("supported_commodities"),
          timers:                d.fetch("timers").map { |x| TimerElement.from_dynamic!(x) },
          transitions:           d.fetch("transitions").map { |x| TransitionElement.from_dynamic!(x) },
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

    module FRBCSystemDescriptionMessageType
      FRBCSystemDescription = "FRBC.SystemDescription"
    end

    # Details of the storage.
    class StorageClass < Dry::Struct

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
      attribute :fill_level_range, FillLevelRangeClass

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
          fill_level_range:                   FillLevelRangeClass.from_dynamic!(d.fetch("fill_level_range")),
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

    class FRBCSystemDescription < Dry::Struct

      # Details of all Actuators.
      attribute :actuators, Types.Array(ActuatorElement)

      # ID of this message
      attribute :message_id, Types::String

      attribute :message_type, Types::FRBCSystemDescriptionMessageType

      # Details of the storage.
      attribute :storage, StorageClass

      # Moment this FRBC.SystemDescription starts to be valid. If the system description is
      # immediately valid, the DateTimeStamp should be now or in the past.
      attribute :valid_from, Types::String

      def self.from_dynamic!(d)
        d = Types::Hash[d]
        new(
          actuators:    d.fetch("actuators").map { |x| ActuatorElement.from_dynamic!(x) },
          message_id:   d.fetch("message_id"),
          message_type: d.fetch("message_type"),
          storage:      StorageClass.from_dynamic!(d.fetch("storage")),
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

    module FRBCTimerStatusMessageType
      FRBCTimerStatus = "FRBC.TimerStatus"
    end

    class FRBCTimerStatus < Dry::Struct

      # The ID of the actuator the timer belongs to
      attribute :actuator_id, Types::String

      # Indicates when the Timer will be finished. If the DateTimeStamp is in the future, the
      # timer is not yet finished. If the DateTimeStamp is in the past, the timer is finished. If
      # the timer was never started, the value can be an arbitrary DateTimeStamp in the past.
      attribute :finished_at, Types::String

      # ID of this message
      attribute :message_id, Types::String

      attribute :message_type, Types::FRBCTimerStatusMessageType

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

    class FRBCUsageForecastElementClass < Dry::Struct

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

    module FRBCUsageForecastMessageType
      FRBCUsageForecast = "FRBC.UsageForecast"
    end

    class FRBCUsageForecast < Dry::Struct

      # Further elements that model the profile. There shall be at least one element. Elements
      # must be placed in chronological order.
      attribute :elements, Types.Array(FRBCUsageForecastElementClass)

      # ID of this message
      attribute :message_id, Types::String

      attribute :message_type, Types::FRBCUsageForecastMessageType

      # Time at which the FRBC.UsageForecast starts.
      attribute :start_time, Types::String

      def self.from_dynamic!(d)
        d = Types::Hash[d]
        new(
          elements:     d.fetch("elements").map { |x| FRBCUsageForecastElementClass.from_dynamic!(x) },
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

    module HandshakeMessageType
      Handshake = "Handshake"
    end

    # CEM: Customer Energy Manager
    # RM: Resource Manager
    #
    # The role of the sender of this message
    module EnergyManagementRole
      Cem = "CEM"
      Rm  = "RM"
    end

    class Handshake < Dry::Struct

      # ID of this message
      attribute :message_id, Types::String

      attribute :message_type, Types::HandshakeMessageType

      # The role of the sender of this message
      attribute :role, Types::EnergyManagementRole

      # Protocol versions supported by the sender of this message. This field is mandatory for
      # the RM, but optional for the CEM.
      attribute :supported_protocol_versions, Types.Array(Types::String).optional

      def self.from_dynamic!(d)
        d = Types::Hash[d]
        new(
          message_id:                  d.fetch("message_id"),
          message_type:                d.fetch("message_type"),
          role:                        d.fetch("role"),
          supported_protocol_versions: d["supported_protocol_versions"],
        )
      end

      def self.from_json!(json)
        from_dynamic!(JSON.parse(json))
      end

      def to_dynamic
        {
          "message_id"                  => message_id,
          "message_type"                => message_type,
          "role"                        => role,
          "supported_protocol_versions" => supported_protocol_versions,
        }
      end

      def to_json(options = nil)
        JSON.generate(to_dynamic, options)
      end
    end

    module HandshakeResponseMessageType
      HandshakeResponse = "HandshakeResponse"
    end

    class HandshakeResponse < Dry::Struct

      # ID of this message
      attribute :message_id, Types::String

      attribute :message_type, Types::HandshakeResponseMessageType

      # The protocol version the CEM selected for this session
      attribute :selected_protocol_version, Types::String

      def self.from_dynamic!(d)
        d = Types::Hash[d]
        new(
          message_id:                d.fetch("message_id"),
          message_type:              d.fetch("message_type"),
          selected_protocol_version: d.fetch("selected_protocol_version"),
        )
      end

      def self.from_json!(json)
        from_dynamic!(JSON.parse(json))
      end

      def to_dynamic
        {
          "message_id"                => message_id,
          "message_type"              => message_type,
          "selected_protocol_version" => selected_protocol_version,
        }
      end

      def to_json(options = nil)
        JSON.generate(to_dynamic, options)
      end
    end

    module InstructionStatusUpdateMessageType
      InstructionStatusUpdate = "InstructionStatusUpdate"
    end

    # NEW: Instruction was newly created
    # ACCEPTED: Instruction has been accepted
    # REJECTED: Instruction was rejected
    # REVOKED: Instruction was revoked
    # STARTED: Instruction was executed
    # SUCCEEDED: Instruction finished successfully
    # ABORTED: Instruction was aborted.
    #
    # Present status of this instruction.
    module InstructionStatus
      Aborted   = "ABORTED"
      Accepted  = "ACCEPTED"
      New       = "NEW"
      Rejected  = "REJECTED"
      Revoked   = "REVOKED"
      Started   = "STARTED"
      Succeeded = "SUCCEEDED"
    end

    class InstructionStatusUpdate < Dry::Struct

      # ID of this instruction (as provided by the CEM)
      attribute :instruction_id, Types::String

      # ID of this message
      attribute :message_id, Types::String

      attribute :message_type, Types::InstructionStatusUpdateMessageType

      # Present status of this instruction.
      attribute :status_type, Types::InstructionStatus

      # Timestamp when status_type has changed the last time.
      attribute :timestamp, Types::String

      def self.from_dynamic!(d)
        d = Types::Hash[d]
        new(
          instruction_id: d.fetch("instruction_id"),
          message_id:     d.fetch("message_id"),
          message_type:   d.fetch("message_type"),
          status_type:    d.fetch("status_type"),
          timestamp:      d.fetch("timestamp"),
        )
      end

      def self.from_json!(json)
        from_dynamic!(JSON.parse(json))
      end

      def to_dynamic
        {
          "instruction_id" => instruction_id,
          "message_id"     => message_id,
          "message_type"   => message_type,
          "status_type"    => status_type,
          "timestamp"      => timestamp,
        }
      end

      def to_json(options = nil)
        JSON.generate(to_dynamic, options)
      end
    end

    class PowerForecastElementClass < Dry::Struct

      # Duration of the PowerForecastElement
      attribute :duration, Types::Integer

      # The values of power that are expected for the given period of time. There shall be at
      # least one PowerForecastValue, and at most one PowerForecastValue per CommodityQuantity.
      attribute :power_values, Types.Array(PowerValueElement)

      def self.from_dynamic!(d)
        d = Types::Hash[d]
        new(
          duration:     d.fetch("duration"),
          power_values: d.fetch("power_values").map { |x| PowerValueElement.from_dynamic!(x) },
        )
      end

      def self.from_json!(json)
        from_dynamic!(JSON.parse(json))
      end

      def to_dynamic
        {
          "duration"     => duration,
          "power_values" => power_values.map { |x| x.to_dynamic },
        }
      end

      def to_json(options = nil)
        JSON.generate(to_dynamic, options)
      end
    end

    module PowerForecastMessageType
      PowerForecast = "PowerForecast"
    end

    class PowerForecast < Dry::Struct

      # Elements of which this forecast consists. Contains at least one element. Elements must be
      # placed in chronological order.
      attribute :elements, Types.Array(PowerForecastElementClass)

      # ID of this message
      attribute :message_id, Types::String

      attribute :message_type, Types::PowerForecastMessageType

      # Start time of time period that is covered by the profile.
      attribute :start_time, Types::String

      def self.from_dynamic!(d)
        d = Types::Hash[d]
        new(
          elements:     d.fetch("elements").map { |x| PowerForecastElementClass.from_dynamic!(x) },
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

    module PowerMeasurementMessageType
      PowerMeasurement = "PowerMeasurement"
    end

    class ValueElement < Dry::Struct

      # The power quantity the value refers to
      attribute :commodity_quantity, Types::CommodityQuantity

      # Power value expressed in the unit associated with the CommodityQuantity
      attribute :value, Types::Double

      def self.from_dynamic!(d)
        d = Types::Hash[d]
        new(
          commodity_quantity: d.fetch("commodity_quantity"),
          value:              d.fetch("value"),
        )
      end

      def self.from_json!(json)
        from_dynamic!(JSON.parse(json))
      end

      def to_dynamic
        {
          "commodity_quantity" => commodity_quantity,
          "value"              => value,
        }
      end

      def to_json(options = nil)
        JSON.generate(to_dynamic, options)
      end
    end

    class PowerMeasurement < Dry::Struct

      # Timestamp when PowerValues were measured.
      attribute :measurement_timestamp, Types::String

      # ID of this message
      attribute :message_id, Types::String

      attribute :message_type, Types::PowerMeasurementMessageType

      # Array of measured PowerValues. Must contain at least one item and at most one item per
      # ‘commodity_quantity’ (defined inside the PowerValue).
      attribute :values, Types.Array(ValueElement)

      def self.from_dynamic!(d)
        d = Types::Hash[d]
        new(
          measurement_timestamp: d.fetch("measurement_timestamp"),
          message_id:            d.fetch("message_id"),
          message_type:          d.fetch("message_type"),
          values:                d.fetch("values").map { |x| ValueElement.from_dynamic!(x) },
        )
      end

      def self.from_json!(json)
        from_dynamic!(JSON.parse(json))
      end

      def to_dynamic
        {
          "measurement_timestamp" => measurement_timestamp,
          "message_id"            => message_id,
          "message_type"          => message_type,
          "values"                => values.map { |x| x.to_dynamic },
        }
      end

      def to_json(options = nil)
        JSON.generate(to_dynamic, options)
      end
    end

    module ReceptionStatusMessageType
      ReceptionStatus = "ReceptionStatus"
    end

    # INVALID_DATA: Message not understood (e.g. not valid JSON, no message_id found).
    # Consequence: Message is ignored, proceed if possible
    # INVALID_MESSAGE: Message was not according to schema. Consequence: Message is ignored,
    # proceed if possible
    # INVALID_CONTENT: Message contents is invalid (e.g. contains a non-existing ID). Somewhat
    # equivalent to BAD_REQUEST in HTTP.. Consequence: Message is ignored, proceed if possible.
    # TEMPORARY_ERROR: Receiver encountered an error. Consequence: Try to send to message again
    # PERMANENT_ERROR: Receiver encountered an error which it cannot recover from. Consequence:
    # Disconnect.
    # OK: Message processed normally. Consequence: Proceed normally.
    #
    # Enumeration of status values
    module ReceptionStatusValues
      InvalidContent = "INVALID_CONTENT"
      InvalidData    = "INVALID_DATA"
      InvalidMessage = "INVALID_MESSAGE"
      Ok             = "OK"
      PermanentError = "PERMANENT_ERROR"
      TemporaryError = "TEMPORARY_ERROR"
    end

    class ReceptionStatus < Dry::Struct

      # Diagnostic label that can be used to provide additional information for debugging.
      # However, not for HMI purposes.
      attribute :diagnostic_label, Types::String.optional

      attribute :message_type, Types::ReceptionStatusMessageType

      # Enumeration of status values
      attribute :status, Types::ReceptionStatusValues

      # The message this ReceptionStatus refers to
      attribute :subject_message_id, Types::String

      def self.from_dynamic!(d)
        d = Types::Hash[d]
        new(
          diagnostic_label:   d["diagnostic_label"],
          message_type:       d.fetch("message_type"),
          status:             d.fetch("status"),
          subject_message_id: d.fetch("subject_message_id"),
        )
      end

      def self.from_json!(json)
        from_dynamic!(JSON.parse(json))
      end

      def to_dynamic
        {
          "diagnostic_label"   => diagnostic_label,
          "message_type"       => message_type,
          "status"             => status,
          "subject_message_id" => subject_message_id,
        }
      end

      def to_json(options = nil)
        JSON.generate(to_dynamic, options)
      end
    end

    # POWER_ENVELOPE_BASED_CONTROL: Identifier for the Power Envelope Based Control type
    # POWER_PROFILE_BASED_CONTROL: Identifier for the Power Profile Based Control type
    # OPERATION_MODE_BASED_CONTROL: Identifier for the Operation Mode Based Control type
    # FILL_RATE_BASED_CONTROL: Identifier for the Demand Driven Based Control type
    # DEMAND_DRIVEN_BASED_CONTROL: Identifier for the Fill Rate Based Control type
    # NOT_CONTROLABLE: Identifier that is to be used if no control is possible. Resources of
    # this type can still provide measurements and forecast
    # NO_SELECTION: Identifier that is to be used if no control type is or has been selected.
    #
    # The ControlType to activate. Must be one of the available ControlTypes as defined in the
    # ResourceManagerDetails
    module ControlType
      DemandDrivenBasedControl  = "DEMAND_DRIVEN_BASED_CONTROL"
      FillRateBasedControl      = "FILL_RATE_BASED_CONTROL"
      NoSelection               = "NO_SELECTION"
      NotControlable            = "NOT_CONTROLABLE"
      OperationModeBasedControl = "OPERATION_MODE_BASED_CONTROL"
      PowerEnvelopeBasedControl = "POWER_ENVELOPE_BASED_CONTROL"
      PowerProfileBasedControl  = "POWER_PROFILE_BASED_CONTROL"
    end

    # Currency used when this resource gives cost information
    #
    # Currency to be used for all information regarding costs. Mandatory if cost information is
    # published.
    module Currency
      Aed = "AED"
      Ang = "ANG"
      Aud = "AUD"
      Che = "CHE"
      Chf = "CHF"
      Chw = "CHW"
      Eur = "EUR"
      Gbp = "GBP"
      Lbp = "LBP"
      Lkr = "LKR"
      Lrd = "LRD"
      Lsl = "LSL"
      Lyd = "LYD"
      Mad = "MAD"
      Mdl = "MDL"
      Mga = "MGA"
      Mkd = "MKD"
      Mmk = "MMK"
      Mnt = "MNT"
      Mop = "MOP"
      Mro = "MRO"
      Mur = "MUR"
      Mvr = "MVR"
      Mwk = "MWK"
      Mxn = "MXN"
      Mxv = "MXV"
      Myr = "MYR"
      Mzn = "MZN"
      NIO = "NIO"
      Nad = "NAD"
      Ngn = "NGN"
      Nok = "NOK"
      Npr = "NPR"
      Nzd = "NZD"
      OMR = "OMR"
      PHP = "PHP"
      Pab = "PAB"
      Pen = "PEN"
      Pgk = "PGK"
      Pkr = "PKR"
      Pln = "PLN"
      Pyg = "PYG"
      Qar = "QAR"
      Ron = "RON"
      Rsd = "RSD"
      Rub = "RUB"
      Rwf = "RWF"
      SSP = "SSP"
      Sar = "SAR"
      Sbd = "SBD"
      Scr = "SCR"
      Sdg = "SDG"
      Sek = "SEK"
      Sgd = "SGD"
      Shp = "SHP"
      Sll = "SLL"
      Sos = "SOS"
      Srd = "SRD"
      Std = "STD"
      Syp = "SYP"
      Szl = "SZL"
      Thb = "THB"
      Tjs = "TJS"
      Tmt = "TMT"
      Tnd = "TND"
      Top = "TOP"
      Try = "TRY"
      Ttd = "TTD"
      Twd = "TWD"
      Tzs = "TZS"
      Uah = "UAH"
      Ugx = "UGX"
      Usd = "USD"
      Usn = "USN"
      Uyi = "UYI"
      Uyu = "UYU"
      Uzs = "UZS"
      Vef = "VEF"
      Vnd = "VND"
      Vuv = "VUV"
      Wst = "WST"
      XAG = "XAG"
      Xau = "XAU"
      Xba = "XBA"
      Xbb = "XBB"
      Xbc = "XBC"
      Xbd = "XBD"
      Xcd = "XCD"
      Xof = "XOF"
      Xpd = "XPD"
      Xpf = "XPF"
      Xpt = "XPT"
      Xsu = "XSU"
      Xts = "XTS"
      Xua = "XUA"
      Xxx = "XXX"
      Yer = "YER"
      Zar = "ZAR"
      Zmw = "ZMW"
      Zwl = "ZWL"
    end

    module ResourceManagerDetailsMessageType
      ResourceManagerDetails = "ResourceManagerDetails"
    end

    class RoleElement < Dry::Struct

      # Commodity the role refers to.
      attribute :commodity, Types::Commodity

      # Role type of the Resource Manager for the given commodity
      attribute :role, Types::RoleType

      def self.from_dynamic!(d)
        d = Types::Hash[d]
        new(
          commodity: d.fetch("commodity"),
          role:      d.fetch("role"),
        )
      end

      def self.from_json!(json)
        from_dynamic!(JSON.parse(json))
      end

      def to_dynamic
        {
          "commodity" => commodity,
          "role"      => role,
        }
      end

      def to_json(options = nil)
        JSON.generate(to_dynamic, options)
      end
    end

    class ResourceManagerDetails < Dry::Struct

      # The control types supported by this Resource Manager.
      attribute :available_control_types, Types.Array(Types::ControlType)

      # Currency to be used for all information regarding costs. Mandatory if cost information is
      # published.
      attribute :currency, Types::Currency.optional

      # Version identifier of the firmware used in the device (provided by the manufacturer)
      attribute :firmware_version, Types::String.optional

      # The average time the combination of Resource Manager and HBES/BACS/SASS or (Smart) device
      # needs to process and execute an instruction
      attribute :instruction_processing_delay, Types::Integer

      # Name of Manufacturer
      attribute :manufacturer, Types::String.optional

      # ID of this message
      attribute :message_id, Types::String

      attribute :message_type, Types::ResourceManagerDetailsMessageType

      # Name of the model of the device (provided by the manufacturer)
      attribute :model, Types::String.optional

      # Human readable name given by user
      attribute :resource_manager_details_name, Types::String.optional

      # Indicates whether the ResourceManager is able to provide PowerForecasts
      attribute :provides_forecast, Types::Bool

      # Array of all CommodityQuantities that this Resource Manager can provide measurements for.
      attribute :provides_power_measurement_types, Types.Array(Types::CommodityQuantity)

      # Identifier of the Resource Manager. Must be unique within the scope of the CEM.
      attribute :resource_id, Types::String

      # Each Resource Manager provides one or more energy Roles
      attribute :roles, Types.Array(RoleElement)

      # Serial number of the device (provided by the manufacturer)
      attribute :serial_number, Types::String.optional

      def self.from_dynamic!(d)
        d = Types::Hash[d]
        new(
          available_control_types:          d.fetch("available_control_types"),
          currency:                         d["currency"],
          firmware_version:                 d["firmware_version"],
          instruction_processing_delay:     d.fetch("instruction_processing_delay"),
          manufacturer:                     d["manufacturer"],
          message_id:                       d.fetch("message_id"),
          message_type:                     d.fetch("message_type"),
          model:                            d["model"],
          resource_manager_details_name:    d["name"],
          provides_forecast:                d.fetch("provides_forecast"),
          provides_power_measurement_types: d.fetch("provides_power_measurement_types"),
          resource_id:                      d.fetch("resource_id"),
          roles:                            d.fetch("roles").map { |x| RoleElement.from_dynamic!(x) },
          serial_number:                    d["serial_number"],
        )
      end

      def self.from_json!(json)
        from_dynamic!(JSON.parse(json))
      end

      def to_dynamic
        {
          "available_control_types"          => available_control_types,
          "currency"                         => currency,
          "firmware_version"                 => firmware_version,
          "instruction_processing_delay"     => instruction_processing_delay,
          "manufacturer"                     => manufacturer,
          "message_id"                       => message_id,
          "message_type"                     => message_type,
          "model"                            => model,
          "name"                             => resource_manager_details_name,
          "provides_forecast"                => provides_forecast,
          "provides_power_measurement_types" => provides_power_measurement_types,
          "resource_id"                      => resource_id,
          "roles"                            => roles.map { |x| x.to_dynamic },
          "serial_number"                    => serial_number,
        }
      end

      def to_json(options = nil)
        JSON.generate(to_dynamic, options)
      end
    end

    module RevokeObjectMessageType
      RevokeObject = "RevokeObject"
    end

    # PEBC.PowerConstraints: Object type PEBC.PowerConstraints
    # PEBC.EnergyConstraint: Object type PEBC.EnergyConstraint
    # PEBC.Instruction: Object type PEBC.Instruction
    # PPBC.PowerProfileDefinition: Object type PPBC.PowerProfileDefinition
    # PPBC.ScheduleInstruction: Object type PPBC.ScheduleInstruction
    # PPBC.StartInterruptionInstruction: Object type PPBC.StartInterruptionInstruction
    # PPBC.EndInterruptionInstruction: Object type PPBC.EndInterruptionInstruction
    # OMBC.SystemDescription: Object type OMBC.SystemDescription
    # OMBC.Instruction: Object type OMBC.Instruction
    # FRBC.SystemDescription: Object type FRBC.SystemDescription
    # FRBC.Instruction: Object type FRBC.Instruction
    # DDBC.SystemDescription: Object type DDBC.SystemDescription
    # DDBC.Instruction: Object type DDBC.Instruction
    #
    # The type of object that needs to be revoked
    module RevokableObjects
      DDBCInstruction                  = "DDBC.Instruction"
      DDBCSystemDescription            = "DDBC.SystemDescription"
      FRBCInstruction                  = "FRBC.Instruction"
      FRBCSystemDescription            = "FRBC.SystemDescription"
      OMBCInstruction                  = "OMBC.Instruction"
      OMBCSystemDescription            = "OMBC.SystemDescription"
      PEBCEnergyConstraint             = "PEBC.EnergyConstraint"
      PEBCInstruction                  = "PEBC.Instruction"
      PEBCPowerConstraints             = "PEBC.PowerConstraints"
      PPBCEndInterruptionInstruction   = "PPBC.EndInterruptionInstruction"
      PPBCPowerProfileDefinition       = "PPBC.PowerProfileDefinition"
      PPBCScheduleInstruction          = "PPBC.ScheduleInstruction"
      PPBCStartInterruptionInstruction = "PPBC.StartInterruptionInstruction"
    end

    class RevokeObject < Dry::Struct

      # ID of this message
      attribute :message_id, Types::String

      attribute :message_type, Types::RevokeObjectMessageType

      # The ID of object that needs to be revoked
      attribute :revoke_object_object_id, Types::String

      # The type of object that needs to be revoked
      attribute :object_type, Types::RevokableObjects

      def self.from_dynamic!(d)
        d = Types::Hash[d]
        new(
          message_id:              d.fetch("message_id"),
          message_type:            d.fetch("message_type"),
          revoke_object_object_id: d.fetch("object_id"),
          object_type:             d.fetch("object_type"),
        )
      end

      def self.from_json!(json)
        from_dynamic!(JSON.parse(json))
      end

      def to_dynamic
        {
          "message_id"   => message_id,
          "message_type" => message_type,
          "object_id"    => revoke_object_object_id,
          "object_type"  => object_type,
        }
      end

      def to_json(options = nil)
        JSON.generate(to_dynamic, options)
      end
    end

    module SelectControlTypeMessageType
      SelectControlType = "SelectControlType"
    end

    class SelectControlType < Dry::Struct

      # The ControlType to activate. Must be one of the available ControlTypes as defined in the
      # ResourceManagerDetails
      attribute :control_type, Types::ControlType

      # ID of this message
      attribute :message_id, Types::String

      attribute :message_type, Types::SelectControlTypeMessageType

      def self.from_dynamic!(d)
        d = Types::Hash[d]
        new(
          control_type: d.fetch("control_type"),
          message_id:   d.fetch("message_id"),
          message_type: d.fetch("message_type"),
        )
      end

      def self.from_json!(json)
        from_dynamic!(JSON.parse(json))
      end

      def to_dynamic
        {
          "control_type" => control_type,
          "message_id"   => message_id,
          "message_type" => message_type,
        }
      end

      def to_json(options = nil)
        JSON.generate(to_dynamic, options)
      end
    end

    module SessionRequestMessageType
      SessionRequest = "SessionRequest"
    end

    # RECONNECT: Please reconnect the WebSocket session. Once reconnected, it starts from
    # scratch with a handshake.
    # TERMINATE: Disconnect the session (client can try to reconnecting with exponential
    # backoff)
    #
    # The type of request
    module SessionRequestType
      Reconnect = "RECONNECT"
      Terminate = "TERMINATE"
    end

    class SessionRequest < Dry::Struct

      # Optional field for a human readible descirption for debugging purposes
      attribute :diagnostic_label, Types::String.optional

      # ID of this message
      attribute :message_id, Types::String

      attribute :message_type, Types::SessionRequestMessageType

      # The type of request
      attribute :request, Types::SessionRequestType

      def self.from_dynamic!(d)
        d = Types::Hash[d]
        new(
          diagnostic_label: d["diagnostic_label"],
          message_id:       d.fetch("message_id"),
          message_type:     d.fetch("message_type"),
          request:          d.fetch("request"),
        )
      end

      def self.from_json!(json)
        from_dynamic!(JSON.parse(json))
      end

      def to_dynamic
        {
          "diagnostic_label" => diagnostic_label,
          "message_id"       => message_id,
          "message_type"     => message_type,
          "request"          => request,
        }
      end

      def to_json(options = nil)
        JSON.generate(to_dynamic, options)
      end
    end

    module S2
      module Messages
        class Duration
          def self.from_json!(json)
            JSON.parse(json, quirks_mode: true)
          end
        end
      end
    end

    module S2
      module Messages
        class ID
          def self.from_json!(json)
            JSON.parse(json, quirks_mode: true)
          end
        end
      end
    end
  end
end
