module S2
  module Messages
    module Types
      include Dry.Types(default: :nominal)

      Hash                 = Strict::Hash
      String               = Strict::String

      MessageType          = Strict::String.enum(
        "Handshake",
        "HandshakeResponse",
        "ReceptionStatus",
      )

      EnergyManagementRole = Strict::String.enum("CEM", "RM")
      ReceptionStatusValues = Strict::String.enum("INVALID_CONTENT", "INVALID_DATA", "INVALID_MESSAGE", "OK", "PERMANENT_ERROR", "TEMPORARY_ERROR")
    end
  end
end
