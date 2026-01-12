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

      connection = described_class.new(
        resource_id:,
        task: Async::Task.current,
        ws_url:,
      )

      allow(connection).to receive(:sleep) { |duration| sleep_durations << duration }

      task = Async do
        connection.connect
      end

      Async::Task.current.sleep 0.1

      connection.disconnect
      task.stop

      expect(sleep_durations).to eq([5, 10, 20, 40, 80, 160, 320, 640, 1280, 2560, 3600, 3600, 3600, 3600])
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

      connection = described_class.new(
        resource_id:,
        task: Async::Task.current,
        ws_url:,
      )

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
  end
end
