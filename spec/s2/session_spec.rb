describe S2::Session do
  describe "#start", :async do
    it "starts and stops the session" do
      ws = FakeWebSocket.new
      resource_id = SecureRandom.uuid
      session = described_class.new(resource_id:, ws:)

      expect(session.status).to eq(:initialized)

      task = Async { session.start }
      Async::Task.current.sleep 0.01

      expect(session.status).to eq(:running)

      session.stop
      Async::Task.current.sleep 0.01

      expect(session.status).to eq(:stopped)

      task.stop
    end

    it "handles incoming messages" do
      ws = FakeWebSocket.new
      message_handler = instance_double(S2::MessageHandler)
      allow(message_handler).to receive(:handle_message)
      allow(S2.message_handler_class).to receive(:new).and_return(message_handler)

      resource_id = SecureRandom.uuid
      session = described_class.new(resource_id:, ws:)
      task = Async { session.start }
      Async::Task.current.sleep 0.01

      ws.simulate_incoming('{"type":"test_message"}')
      Async::Task.current.sleep 0.01

      expect(message_handler).to have_received(:handle_message).with('{"type":"test_message"}')

      session.stop
      task.stop
    end

    it "sends outgoing messages" do
      ws = FakeWebSocket.new
      queue = Async::Queue.new
      resource_id = SecureRandom.uuid
      session = described_class.new(resource_id:, ws:, queue:)

      task = Async { session.start }

      queue.enqueue({ type: "outgoing_message" })

      Async::Task.current.sleep 0.01

      expect(ws.sent_messages).to include('{"type":"outgoing_message"}')

      session.stop
      task.stop
    end
  end

  describe "#stop", :async do
    it "is idempotent" do
      ws = FakeWebSocket.new
      resource_id = SecureRandom.uuid
      session = described_class.new(resource_id:, ws:)

      expect(session.status).to eq(:initialized)

      task = Async { session.start }
      Async::Task.current.sleep 0.01

      expect(session.status).to eq(:running)

      session.stop
      Async::Task.current.sleep 0.01

      expect(session.status).to eq(:stopped)

      # Call stop again to ensure idempotency
      session.stop
      Async::Task.current.sleep 0.01

      expect(session.status).to eq(:stopped)

      task.stop
    end

    it "cleans up the message sender" do
      ws = FakeWebSocket.new
      resource_id = SecureRandom.uuid
      message_sender = instance_double(S2::MessageSender)
      allow(S2::MessageSender).to receive(:new).and_return(message_sender)
      session = described_class.new(resource_id:, ws:)
      allow(message_sender).to receive(:cleanup)

      task = Async { session.start }
      Async::Task.current.sleep 0.01

      session.stop
      Async::Task.current.sleep 0.01

      expect(message_sender).to have_received(:cleanup)

      task.stop
    end

    it "closes the WebSocket connection" do
      ws = FakeWebSocket.new
      resource_id = SecureRandom.uuid
      session = described_class.new(resource_id:, ws:)

      task = Async { session.start }
      Async::Task.current.sleep 0.01

      expect(ws).not_to be_closed

      session.stop
      Async::Task.current.sleep 0.01

      expect(ws).to be_closed

      task.stop
    end
  end
end
