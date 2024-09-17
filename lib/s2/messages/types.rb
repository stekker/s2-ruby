module S2
  module Messages
    module Types
      include Dry.Types(default: :nominal)

      Integer = Strict::Integer
      Bool = Strict::Bool
      Hash = Strict::Hash
      String = Strict::String
      Double = Strict::Float | Strict::Integer

      MessageType = Strict::String.enum(
        "FRBC.ActuatorStatus",
        "FRBC.FillLevelTargetProfile",
        "FRBC.Instruction",
        "FRBC.LeakageBehaviour",
        "FRBC.StorageStatus",
        "FRBC.SystemDescription",
        "FRBC.TimerStatus",
        "FRBC.UsageForecast",
        "FRBC.UsageForecast",
        "Handshake",
        "HandshakeResponse",
        "ReceptionStatus",
        "ResourceManagerDetails"
      )

      Commodity = Strict::String.enum("ELECTRICITY", "GAS", "HEAT", "OIL")
      CommodityQuantity = Strict::String.enum("ELECTRIC.POWER.3_PHASE_SYMMETRIC", "ELECTRIC.POWER.L1", "ELECTRIC.POWER.L2", "ELECTRIC.POWER.L3", "HEAT.FLOW_RATE", "HEAT.TEMPERATURE", "HEAT.THERMAL_POWER", "HYDROGEN.FLOW_RATE", "NATURAL_GAS.FLOW_RATE", "OIL.FLOW_RATE")
      ControlType = Strict::String.enum("DEMAND_DRIVEN_BASED_CONTROL", "FILL_RATE_BASED_CONTROL", "NO_SELECTION", "NOT_CONTROLABLE", "OPERATION_MODE_BASED_CONTROL", "POWER_ENVELOPE_BASED_CONTROL", "POWER_PROFILE_BASED_CONTROL")
      Currency = Strict::String.enum("AED", "ANG", "AUD", "CHE", "CHF", "CHW", "EUR", "GBP", "LBP", "LKR", "LRD", "LSL", "LYD", "MAD", "MDL", "MGA", "MKD", "MMK", "MNT", "MOP", "MRO", "MUR", "MVR", "MWK", "MXN", "MXV", "MYR", "MZN", "NIO", "NAD", "NGN", "NOK", "NPR", "NZD", "OMR", "PHP", "PAB", "PEN", "PGK", "PKR", "PLN", "PYG", "QAR", "RON", "RSD", "RUB", "RWF", "SSP", "SAR", "SBD", "SCR", "SDG", "SEK", "SGD", "SHP", "SLL", "SOS", "SRD", "STD", "SYP", "SZL", "THB", "TJS", "TMT", "TND", "TOP", "TRY", "TTD", "TWD", "TZS", "UAH", "UGX", "USD", "USN", "UYI", "UYU", "UZS", "VEF", "VND", "VUV", "WST", "XAG", "XAU", "XBA", "XBB", "XBC", "XBD", "XCD", "XOF", "XPD", "XPF", "XPT", "XSU", "XTS", "XUA", "XXX", "YER", "ZAR", "ZMW", "ZWL")
      EnergyManagementRole = Strict::String.enum("CEM", "RM")
      ReceptionStatusValues = Strict::String.enum("INVALID_CONTENT", "INVALID_DATA", "INVALID_MESSAGE", "OK", "PERMANENT_ERROR", "TEMPORARY_ERROR")
      RoleType = Strict::String.enum("ENERGY_CONSUMER", "ENERGY_PRODUCER", "ENERGY_STORAGE")
    end
  end
end
