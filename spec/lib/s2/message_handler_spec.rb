describe S2::MessageHandler do
  describe ".on" do
    it "routes a message to the registered handler" do
      message_class = Class.new
      handler_class = Class.new do
        include S2::MessageHandler

        attr_reader :received_messages

        def initialize
          @received_messages = []
        end

        on message_class do |message|
          @received_messages << message
        end
      end

      handler = handler_class.new
      message = message_class.new

      expect { handler.handle_message(message) }.to change { handler.received_messages }.to([message])
    end

    it "raises when a duplicate handler is defined" do
      message_class = Class.new
      stub_const("TestNamespace::TestMessage", message_class)

      expect do
        Class.new do
          include S2::MessageHandler

          on message_class do |message|
            # no-op
          end

          on message_class do |message|
            # no-op
          end
        end
      end.to raise_error(ArgumentError, "A handler for message class 'TestNamespace::TestMessage' already exists")
    end

    it "raises when no handler could be found for the given message" do
      message_class = Class.new
      handler_class = Class.new do
        include S2::MessageHandler
      end

      handler = handler_class.new
      message = message_class.new

      expect { handler.handle_message(message) }
        .to raise_error(ArgumentError, "No handler found for message class '#{message.class}'")
    end
  end
end
