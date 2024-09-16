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
        "Handshake",
        "HandshakeResponse",
        "ReceptionStatus",
        "FRBC.StorageStatus",
        "FRBC.Instruction",
        "FRBC.ActuatorStatus",
        "FRBC.UsageForecast",
        "FRBC.FillLevelTargetProfile",
        "FRBC.LeakageBehaviour",
        "FRBC.TimerStatus",
        "FRBC.UsageForecast",
      )

      CommodityQuantity = Strict::String.enum("ELECTRIC.POWER.3_PHASE_SYMMETRIC", "ELECTRIC.POWER.L1", "ELECTRIC.POWER.L2", "ELECTRIC.POWER.L3", "HEAT.FLOW_RATE", "HEAT.TEMPERATURE", "HEAT.THERMAL_POWER", "HYDROGEN.FLOW_RATE", "NATURAL_GAS.FLOW_RATE", "OIL.FLOW_RATE")
      Commodity = Strict::String.enum("ELECTRICITY", "GAS", "HEAT", "OIL")
      EnergyManagementRole = Strict::String.enum("CEM", "RM")
      ReceptionStatusValues = Strict::String.enum("INVALID_CONTENT", "INVALID_DATA", "INVALID_MESSAGE", "OK", "PERMANENT_ERROR", "TEMPORARY_ERROR")
    end
  end
end
