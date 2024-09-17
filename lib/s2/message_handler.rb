module S2
  module MessageHandler
    extend ActiveSupport::Concern

    included do
      class_attribute :message_handlers, instance_writer: false, default: {}
    end

    class_methods do
      def on(message_class, &handler)
        if find_handler(message_class)
          raise ArgumentError, "A handler for message class '#{message_class}' is already defined"
        end

        self.message_handlers = message_handlers.merge(key(message_class) => handler)
      end

      def key(message_class)
        message_class
      end

      def find_handler(message_class)
        message_handlers[key(message_class)]
      end
    end

    def handle_message(message)
      handler = self.class.find_handler(message.class)
      raise ArgumentError, "No handler defined for message class '#{message.class}'" if handler.nil?

      instance_exec(message, &handler)
    end
  end
end
