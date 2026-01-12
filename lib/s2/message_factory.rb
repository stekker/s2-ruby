module S2
  class MessageFactory
    MESSAGE_TYPE_TO_MESSAGE_CLASS = {
      "FRBC.ActuatorStatus" => S2::Messages::FRBCActuatorStatus,
      "FRBC.FillLevelTargetProfile" => S2::Messages::FRBCFillLevelTargetProfile,
      "FRBC.Instruction" => S2::Messages::FRBCInstruction,
      "FRBC.LeakageBehaviour" => S2::Messages::FRBCLeakageBehaviour,
      "FRBC.StorageStatus" => S2::Messages::FRBCStorageStatus,
      "FRBC.SystemDescription" => S2::Messages::FRBCSystemDescription,
      "FRBC.TimerStatus" => S2::Messages::FRBCTimerStatus,
      "FRBC.UsageForecast" => S2::Messages::FRBCUsageForecast,
      "Handshake" => S2::Messages::Handshake,
      "HandshakeResponse" => S2::Messages::HandshakeResponse,
      "InstructionStatusUpdate" => S2::Messages::InstructionStatusUpdate,
      "PowerForecast" => S2::Messages::PowerForecast,
      "PowerMeasurement" => S2::Messages::PowerMeasurement,
      "ReceptionStatus" => S2::Messages::ReceptionStatus,
      "ResourceManagerDetails" => S2::Messages::ResourceManagerDetails,
      "RevokeObject" => S2::Messages::RevokeObject,
      "SelectControlType" => S2::Messages::SelectControlType,
      "SessionRequest" => S2::Messages::SessionRequest,
    }.freeze

    class BaseError < StandardError
      attr_reader :message_id

      def initialize(message, message_id = nil)
        super(message)
        @message_id = message_id
      end
    end

    class InvalidMessageFormat < BaseError; end
    class MissingMessageType < BaseError; end
    class UnsupportedMessageType < BaseError; end
    class InvalidMessagePayload < BaseError; end

    class << self
      def create_message(data)
        message = data.is_a?(String) ? parse_json(data) : data
        message_type = message["message_type"]
        message_id = message["message_id"]

        raise(MissingMessageType, "Message type not provided", message_id) if message_type.blank?

        message_class = MESSAGE_TYPE_TO_MESSAGE_CLASS[message_type]

        if message_class.nil?
          raise(
            UnsupportedMessageType,
            "Message type not supported: #{message_type}",
            message_id,
          )
        end

        build_message(message_class, message)
      end

      private

      def parse_json(data)
        JSON.parse(data)
      rescue JSON::ParserError
        raise(InvalidMessageFormat, "Invalid JSON")
      end

      def build_message(message_class, message)
        message_class.from_dynamic!(message)
      rescue KeyError => e
        raise(InvalidMessagePayload, "Field missing in payload: #{e.key}", message["message_id"])
      end
    end
  end
end
