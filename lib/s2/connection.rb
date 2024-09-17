module S2
  class Connection
    include S2::MessageHandler
    include S2::MessageHandlerCallbacks

    attr_reader :state, :sent_messages

    on S2::Messages::ReceptionStatus do |message|
      if message_sent?(message.subject_message_id)
        delete_sent_message(message)
        close if message.status == S2::Messages::ReceptionStatusValues::PermanentError
      else
        @logger.error("Received ReceptionStatus for unknown message ID #{message.subject_message_id}")
      end
    end

    def initialize(ws, logger: Rails.logger)
      @ws = ws
      @logger = logger
      @sent_messages = {}
      @context = nil

      update_state :connected
    end

    def open(context)
      @context = context
      trigger_on_open(context)
    end

    def receive_message(message_json)
      trigger_before_receive(@context, message_json)
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
      trigger_after_send(@context, json)

      @logger.info("Sent message: #{json}")
    end

    def send_raw_message(data)
      @logger.info("Send raw message: #{data}")
      @ws.write(data)
    end

    def close(message: nil)
      send_raw_message(message) if message
      @ws.close
    end

    def notify_closed(rm_id)
      trigger_on_close(rm_id)
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
    end

    def update_state(new_state)
      @state = new_state
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
