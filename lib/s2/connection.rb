module S2
  class Connection
    INITIAL_BACKOFF = 5.seconds
    MAX_BACKOFF = 1.hour

    delegate :state,
             to: :@session,
             allow_nil: true

    attr_reader :connected_at, :status

    def initialize(resource_id:, task:, ws_url:)
      @connected_at = nil
      @queue = nil
      @resource_id = resource_id
      @session = nil
      @task = task
      @ws_url = ws_url
      @status = :initialized
      @stopping = false
      @backoff = INITIAL_BACKOFF
      @endpoint = Async::HTTP::Endpoint.parse(
        ws_url,
        alpn_protocols: Async::HTTP::Protocol::HTTP11.names,
      )
    end

    def connect
      until @stopping
        begin
          connect_and_run
          @backoff = INITIAL_BACKOFF
        rescue StandardError => e
          ActiveSupport::Notifications.instrument("connection_errored.session.s2", exception: e) unless @stopping
        ensure
          break if @stopping

          S2.logger.info "[#{self.class.name}] [#{@resource_id}] Reconnecting in #{@backoff}s..."
          @status = :reconnecting
          sleep @backoff
          @backoff = [@backoff * 2, MAX_BACKOFF].min
        end
      end
    end

    def disconnect
      @status = :disconnecting
      @stopping = true
      @session&.stop

      begin
        @queue&.close
      rescue StandardError
        # ignore
      end

      @status = :disconnected
    end

    def send_message(message)
      @queue.push(message)
    end

    private

    def connect_and_run
      connect_websocket do |ws|
        @queue = Async::Queue.new
        @session = S2::Session.new(resource_id: @resource_id, ws:, queue: @queue)
        @connected_at = Time.current
        @status = :connected
        send_handshake
        @session.start
      ensure
        @session = nil
        @queue = nil
        @status = :disconnected
      end
    end

    def connect_websocket(&)
      @status = :connecting

      Async::WebSocket::Client.connect(@endpoint) do |ws|
        ActiveSupport::Notifications.instrument(
          "connected.session.s2",
          resource_id: @resource_id,
          url: @ws_url,
        )

        yield ws
      ensure
        ActiveSupport::Notifications.instrument(
          "disconnected.session.s2",
          resource_id: @resource_id,
        )
      end
    end

    def send_handshake
      handshake = S2::Messages::Handshake.new(
        message_id: SecureRandom.uuid,
        message_type: S2::Messages::HandshakeMessageType::Handshake,
        role: S2::Messages::EnergyManagementRole::Rm,
        supported_protocol_versions: S2.supported_protocol_versions,
      )

      send_message(handshake)
    end
  end
end
