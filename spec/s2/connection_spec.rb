describe S2::Connection, :async do
  describe "#connect" do
    it "uses exponential backoff for reconnection attempts up to 1 hour" do
      ws = FakeWebSocket.new
      connection_attempts = 0
      sleep_durations = []

      allow(Async::WebSocket::Client).to receive(:connect) do |_endpoint, &block|
        connection_attempts += 1
        raise Errno::ECONNREFUSED if connection_attempts < 15

        block.call(ws)
      end

      resource_id = SecureRandom.uuid
      ws_url = "ws://example.com/#{resource_id}"

      connection = described_class.new(resource_id:, ws_url:)

      allow(connection).to receive(:sleep) { |duration| sleep_durations << duration }

      task = Async do
        connection.connect
      end

      Async::Task.current.sleep 0.1

      connection.disconnect
      task.stop

      expect(sleep_durations).to eq([5, 10, 20, 40, 80, 160, 320, 640, 1280, 2560, 3600, 3600, 3600, 3600])
    end

    it "passes headers to the websocket client" do
      ws = FakeWebSocket.new
      received_headers = nil

      allow(Async::WebSocket::Client).to receive(:connect) do |_endpoint, headers:, &block|
        received_headers = headers
        block.call(ws)
      end

      resource_id = SecureRandom.uuid
      ws_url = "ws://example.com/#{resource_id}"
      headers = { "authorization" => "Basic dXNlcjpwYXNz" }

      connection = described_class.new(resource_id:, ws_url:, headers:)

      task = Async do
        connection.connect
      end

      Async::Task.current.sleep 0.1

      connection.disconnect
      task.stop

      expect(received_headers).to eq(headers)
    end

    it "reuses the same endpoint across reconnection attempts" do
      ws = FakeWebSocket.new
      connection_attempts = []

      allow(Async::WebSocket::Client).to receive(:connect) do |endpoint, &block|
        connection_attempts << endpoint.object_id
        raise Errno::ECONNREFUSED if connection_attempts.size < 3

        block.call(ws)
      end

      resource_id = SecureRandom.uuid
      ws_url = "ws://example.com/#{resource_id}"

      connection = described_class.new(resource_id:, ws_url:)

      allow(connection).to receive(:sleep)

      task = Async do
        connection.connect
      end

      Async::Task.current.sleep 0.1

      connection.disconnect
      task.stop

      expect(connection_attempts.size).to be >= 3
      expect(connection_attempts.uniq.size).to eq(1)
    end

    it "stops its task when disconnected, even while sleeping between reconnect attempts" do
      allow(Async::WebSocket::Client).to receive(:connect).and_raise(Errno::ECONNREFUSED)

      resource_id = SecureRandom.uuid
      ws_url = "ws://example.com/#{resource_id}"

      connection = described_class.new(resource_id:, ws_url:)

      task = Async { connection.connect }
      Async::Task.current.sleep 0.1

      expect(task).not_to be_finished

      connection.disconnect

      Async::Task.current.sleep 0.1
      expect(task).to be_finished
    end

    it "instruments connection_errored with the resource_id and exception" do
      ws = FakeWebSocket.new
      connection_attempts = 0
      raised = Errno::ECONNREFUSED.new

      allow(Async::WebSocket::Client).to receive(:connect) do |_endpoint, &block|
        connection_attempts += 1
        raise raised if connection_attempts < 2

        block.call(ws)
      end

      resource_id = SecureRandom.uuid
      events = []
      subscriber = ActiveSupport::Notifications.subscribe("connection_errored.session.s2") do |event|
        events << event
      end

      connection = described_class.new(
        resource_id:,
        ws_url: "ws://example.com/#{resource_id}",
      )
      allow(connection).to receive(:sleep)

      task = Async { connection.connect }
      Async::Task.current.sleep 0.1
      connection.disconnect
      task.stop

      expect(events).not_to be_empty
      expect(events.first.payload).to eq(resource_id:, exception: raised)
    ensure
      ActiveSupport::Notifications.unsubscribe(subscriber) if subscriber
    end
  end
end
