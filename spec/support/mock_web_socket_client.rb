class MockWebSocketClient
  attr_reader :remote_ip, :sent_messages

  def initialize(remote_ip: "1.2.3.4")
    @remote_ip = remote_ip
    @sent_messages = []
    @closed = false
  end

  def on(type, &blk)
    instance_variable_set("@on#{type}", blk)
  end

  def write(message)
    @sent_messages << message
  end

  def close
    @closed = true
  end

  def closed?
    @closed
  end

  def has_sent_message?(message)
    @sent_messages.include?(message)
  end

  def trigger_on_close(event) = @onclose.call(event)
  def trigger_on_message(msg) = @onmessage.call(msg)
  def trigger_on_open(handshake) = @onopen.call(handshake)
end
