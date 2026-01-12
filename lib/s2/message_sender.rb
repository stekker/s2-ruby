module S2
  class MessageSender
    attr_reader :timeout_tasks

    def initialize(resource_id:, &send_proc)
      raise ArgumentError, "Provide a block to send messages" unless block_given?

      @resource_id = resource_id
      @send_proc = send_proc
      @success_callbacks = {}
      @notes = {}
      @timeout_tasks = {}
    end

    def send_message(message, timeout: 5.0, &on_success)
      json = serialize_message(message)
      transmit(json)
      log_sent(json)

      return unless block_given?

      register_success_callback(message.message_id, on_success)
      start_timeout_watch(message.message_id, timeout)
    end

    def receive_reception_status(reception_status)
      message_id = reception_status.subject_message_id

      if (note = @notes&.delete(message_id))
        note.signal
      end

      cancel_timeout_task(message_id)
      handle_incoming_status(message_id, reception_status)
    end

    def cleanup
      S2.logger.info { "[#{self.class.name}] Cleaning up" }

      stop_all_timeout_tasks
      clear_all_callbacks
    end

    private

    def serialize_message(message)
      message.to_json
    end

    def transmit(json)
      @send_proc.call(json)
    end

    def log_sent(json)
      ActiveSupport::Notifications.instrument(
        "message_sent.session.s2",
        resource_id: @resource_id,
        payload: json,
      )
    end

    def register_success_callback(message_id, on_success)
      @success_callbacks[message_id] = on_success
    end

    def start_timeout_watch(message_id, timeout)
      note = @notes[message_id] = Async::Notification.new
      task = Async do |t|
        t.with_timeout(timeout) { note.wait }
      rescue Async::TimeoutError
        handle_timeout_if_pending(message_id)
      ensure
        remove_timeout_task(message_id)
        @notes.delete(message_id)
      end

      @timeout_tasks[message_id] = task
    end

    def handle_timeout_if_pending(message_id)
      return unless @success_callbacks.delete(message_id)

      S2.logger.warn { "[#{self.class.name}] Timeout waiting for ReceptionStatus for #{message_id}" }
    end

    def remove_timeout_task(message_id)
      @timeout_tasks.delete(message_id)
    end

    def cancel_timeout_task(message_id)
      if (task = @timeout_tasks.delete(message_id))
        begin
          task.stop
        rescue StandardError
          # task already stopped
        end
      end
    end

    def handle_incoming_status(message_id, reception_status)
      if ok_status?(reception_status)
        handle_ok_status(message_id, reception_status)
      else
        handle_non_ok_status(message_id, reception_status)
      end
    end

    def handle_ok_status(message_id, reception_status)
      if (callback = @success_callbacks.delete(message_id))
        S2.logger.debug { "[#{self.class.name}] Calling success for #{message_id}" }
        callback.call(reception_status)
      else
        S2.logger.debug { "[#{self.class.name}] OK for #{message_id} but no success block registered" }
      end
    end

    def handle_non_ok_status(message_id, reception_status)
      diag = reception_status.diagnostic_label

      S2.logger.warn do
        "[#{self.class.name}] Non-OK ReceptionStatus for #{message_id}: " \
          "#{reception_status.status}#{" (#{diag})" if diag}"
      end

      @success_callbacks.delete(message_id)
    end

    def stop_all_timeout_tasks
      @timeout_tasks.each_value do |task|
        task.stop
      rescue StandardError
        # ignore
      end
      @timeout_tasks.clear
    end

    def clear_all_callbacks
      @success_callbacks.clear
    end

    def ok_status?(reception_status)
      reception_status.status == S2::Messages::ReceptionStatusValues::Ok
    end
  end
end
