module S2
  class Session
    delegate :state, to: :@message_handler
    attr_reader :status

    def initialize(resource_id:, ws:, queue: nil)
      @resource_id = resource_id
      @ws = ws
      @queue = queue || Async::Queue.new
      @status = :initialized
      @message_sender = S2::MessageSender.new(resource_id: @resource_id) do |payload|
        @ws.write(payload)
        @ws.flush
      end
      @message_handler = S2.message_handler_class.new(
        message_sender: @message_sender,
        state: {
          resource_id: @resource_id,
          status: :websocket_connected,
        },
      )
    end

    def start
      return if @status == :running

      run
    ensure
      stop
    end

    def stop
      return if @status == :stopped

      @message_sender.cleanup
      @ws&.close
    ensure
      @ws = nil
      @status = :stopped

      ActiveSupport::Notifications.instrument("stopped.session.s2", resource_id: @resource_id)
    end

    private

    def run
      @status = :running

      sender = Async do
        while (message = @queue.dequeue)
          @message_sender.send_message(message)
        end
      end

      ActiveSupport::Notifications.instrument("started.session.s2", resource_id: @resource_id)

      while (payload = @ws.read)
        ActiveSupport::Notifications.instrument(
          "message_received.session.s2",
          resource_id: @resource_id,
          payload: payload.to_str,
        )

        @message_handler.handle_message(payload.to_str)
      end

      sender.stop
    end
  end
end
