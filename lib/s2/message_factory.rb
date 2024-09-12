module S2
  module MessageFactory
    class InvalidMessageType < StandardError; end

    class << self
      def create(hash)
        message_type = hash["message_type"]
        "S2::Messages::#{message_type}".constantize.from_dynamic!(hash)
      rescue NameError
        raise InvalidMessageType, "Unknown message type: '#{message_type}'"
      end
    end
  end
end
