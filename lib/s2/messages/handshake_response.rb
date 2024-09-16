module S2
  module Messages
    module MessageType
      HandshakeResponse = "HandshakeResponse"
    end

    class HandshakeResponse < Dry::Struct

      # ID of this message
      attribute :message_id, Types::String

      attribute :message_type, Types::MessageType

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
  end
end
