module S2::MessageHandler::Dispatching
  extend ActiveSupport::Concern

  class HandlerNotFound < StandardError; end

  included do
    class_attribute :handlers, instance_writer: false, default: {}.freeze
  end

  class_methods do
    def on(type, &)
      raise ArgumentError, "Handler already registered for #{type}" if handler_registered?(type)

      register_handler(type, &)
    end

    def handler_for(type)
      handlers[type.to_s]
    end

    private

    def handler_registered?(type)
      handlers.has_key?(type.to_s)
    end

    def register_handler(type, &block)
      new_map = handlers.dup
      new_map[type.to_s] = block
      self.handlers = new_map.freeze
    end
  end

  def dispatch_message(message, type: message.class)
    raise ArgumentError, "Missing message type" if type.blank?

    handler = self.class.handler_for(type)

    raise(HandlerNotFound, "No handler registered for #{type}") unless handler

    instance_exec(message, &handler)
  end
end
