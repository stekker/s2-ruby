# This code may look unusually verbose for Ruby (and it is), but
# it performs some subtle and complex validation of JSON data.
#
# To parse this JSON, add 'dry-struct' and 'dry-types' gems, then do:
#
#   handshake = Handshake.from_json! "{…}"
#   puts handshake.supported_protocol_versions&.first
#
# If from_json! succeeds, the value returned matches the schema.

module S2
  module Messages
    module MessageType
      Handshake = "Handshake"
    end

    # The role of the sender of this message
    #
    # CEM: Customer Energy Manager
    # RM: Resource Manager
    module EnergyManagementRole
      Cem = "CEM"
      Rm  = "RM"
    end

    class Handshake < Dry::Struct

      # ID of this message
      attribute :message_id, Types::String

      attribute :message_type, Types::MessageType

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
  end
end
