module S2
  class Connection
    include S2::MessageHandler

    on S2::Messages::ReceptionStatus do |message|
      unless message_sent?(message.subject_message_id)
        @logger.error("Received ReceptionStatus for unknown message ID #{message.subject_message_id}")
      end

      case message.status
      when S2::Messages::ReceptionStatusValues::Ok
        # no-op
      else
        @logger.error(
          "Received ReceptionStatus with status #{message.status} " \
          "for message ID #{message.subject_message_id}",
        )
      end

      delete_sent_message(message)
    end

    def initialize(ws, logger: Rails.logger)
      @ws = ws
      @logger = logger
      @state = :connected
      @sent_messages = {}
    end

    def receive_message(message_json)
      @logger.info("Received message: #{message_json}")

      message = deserialize_message(message_json)
      handle_message(message)
    rescue JSON::ParserError
      @logger.error("Received invalid JSON: #{message_json}")
    rescue KeyError => e
      @logger.error("JSON #{message_json} is missing required key: #{e.message}")
    end

    def send_message(message_class, payload)
      message = serialize_message(message_class, payload)
      store_sent_message(message) unless message.is_a?(S2::Messages::ReceptionStatus)
      json = message.to_json
      send_raw_message(json)

      @logger.info("Sent message: #{json}")
    end

    def send_raw_message(data)
      @logger.info("Send raw message: #{data}")
      @ws.send(data)
    end

    def close(message: nil)
      send_raw_message(message) if message
      @ws.close
    end

    protected

    def reply(message, status:)
      if message.is_a?(S2::Messages::ReceptionStatus)
        @logger.error("Cannot reply to ReceptionStatus message")
      else
        send_message(
          S2::Messages::ReceptionStatus,
          status:,
          subject_message_id: message.message_id,
        )
      end

      @ws.close if status == S2::Messages::ReceptionStatusValues::PermanentError
    end

    def message_sent?(message_id)
      @sent_messages.has_key?(message_id)
    end

    def connected?
      @state == :connected
    end

    private

    def deserialize_message(message_json)
      S2::MessageFactory.create(JSON.parse(message_json))
    end

    def serialize_message(message_class, payload)
      S2::MessageFactory
        .create(
          payload
            .merge(
              message_id: SecureRandom.uuid,
              message_type: message_class.name.demodulize,
            )
            .with_indifferent_access,
        )
    end

    def store_sent_message(message)
      @sent_messages[message.message_id] = message
    end

    def delete_sent_message(message)
      @sent_messages.delete(message.subject_message_id)
    end
  end
end
