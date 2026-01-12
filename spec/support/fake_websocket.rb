class FakeWebSocket
  attr_reader :sent_messages

  def initialize
    @incoming = Async::Queue.new
    @buffered_messages = []
    @sent_messages = []
    @closed = false
  end

  def read
    return nil if @closed

    @incoming.dequeue
  rescue Async::Stop
    nil
  end

  def write(payload)
    @buffered_messages << payload
  end

  def flush
    @sent_messages.concat(@buffered_messages)
    @buffered_messages.clear
  end

  def close
    @closed = true
    @incoming.enqueue(nil) # Unblock any waiting reads
  end

  def simulate_incoming(payload)
    @incoming.enqueue(payload)
  end

  def closed?
    @closed
  end
end
