module S2
  module Messages
    module MessageType
      FRBCStorageStatus = "FRBC.StorageStatus"
    end

    class FrbcStorageStatus < Dry::Struct

      # ID of this message
      attribute :message_id, Types::String

      attribute :message_type, Types::MessageType

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
  end
end
