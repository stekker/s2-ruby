class MessageSenderStub < S2::MessageSender
  attr_reader :sent_messages

  def initialize
    super(resource_id: FactoryBot.generate(:uuid)) do |_message|
      # ignored
    end

    @sent_messages = []
  end

  def send_message(message, &)
    @sent_messages << message

    yield if block_given?
  end
end
