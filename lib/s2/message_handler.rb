module S2
  module MessageHandler
    extend ActiveSupport::Concern

    included do
      class_attribute :handlers, default: {}
    end

    class_methods do
      def on(message_type, &handler)
        if handlers.has_key?(message_type)
          raise ArgumentError, "A handler for message class '#{message_type}' already exists"
        end

        handlers[message_type] = handler
      end
    end

    def handle_message(message)
      handler = self.class.handlers[message.class]
      raise ArgumentError, "No handler found for message class '#{message.class}'" if handler.nil?

      instance_exec(message, &handler)
    end
  end
end
