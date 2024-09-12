# This code may look unusually verbose for Ruby (and it is), but
# it performs some subtle and complex validation of JSON data.
#
# To parse this JSON, add 'dry-struct' and 'dry-types' gems, then do:
#
#   reception_status = ReceptionStatus.from_json! "{…}"
#   puts reception_status.diagnostic_label
#
# If from_json! succeeds, the value returned matches the schema.

module S2
  module Messages
    module MessageType
      ReceptionStatus = "ReceptionStatus"
    end

    # Enumeration of status values
    #
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

      attribute :message_type, Types::MessageType

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
  end
end
