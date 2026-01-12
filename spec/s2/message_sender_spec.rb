describe S2::MessageSender do
  describe "#send_message" do
    it "sends payload when no success block is given" do
      message = build(:s2_handshake)
      sent_messages = []
      sender = described_class.new(resource_id: generate(:uuid)) { |json| sent_messages << json }

      sender.send_message(message)

      expect(sent_messages).to eq([message.to_json])
    end

    it "registers a success block and does not log a timeout when OK arrives in time" do
      allow(S2.logger).to receive(:warn)
      message = build(:s2_handshake)
      reception_status = build(:s2_reception_status, subject_message_id: message.message_id)
      sent_messages = []
      sender = described_class.new(resource_id: generate(:uuid)) { |json| sent_messages << json }

      called = nil
      Async do |task|
        sender.send_message(message, timeout: 0.01) { |status| called = status }
        sender.receive_reception_status(reception_status)
        task.sleep 0.02
      end

      expect(called).to eq(reception_status)
      expect(S2.logger).not_to have_received(:warn)
    end

    it "logs a warning on timeout when no status arrives" do
      allow(S2.logger).to receive(:warn)
      message = build(:s2_handshake)
      sender = described_class.new(resource_id: generate(:uuid)) do |_json|
        # omit sending
      end

      Async do |task|
        sender.send_message(message, timeout: 0.01) { |_| raise "should not be called" }
        task.sleep 0.02
      end

      expect(S2.logger).to have_received(:warn) { |&blk|
        expect(blk.call).to match(/Timeout waiting for ReceptionStatus for #{message.message_id}/)
      }
    end
  end

  describe "#receive_reception_status" do
    it "only logs for non-OK and does not call the success block" do
      allow(S2.logger).to receive(:warn)
      message = build(:s2_handshake)
      not_ok = build(:s2_reception_status, :permanent_error, subject_message_id: message.message_id)
      sender = described_class.new(resource_id: generate(:uuid)) do |_json|
        # omit sending
      end

      called = nil
      Async do |task|
        sender.send_message(message, timeout: 0.01) { |status| called = status }
        sender.receive_reception_status(not_ok)
        task.sleep 0.02
      end

      expect(called).to be_nil
      expect(S2.logger).to have_received(:warn) { |&blk|
        expect(blk.call).to include("Non-OK ReceptionStatus for #{message.message_id}: PERMANENT_ERROR")
      }
    end

    it "handles OK when no success block was registered" do
      allow(S2.logger).to receive(:debug)
      message = build(:s2_handshake)
      reception_status = build(:s2_reception_status, subject_message_id: message.message_id)
      sent_messages = []
      sender = described_class.new(resource_id: generate(:uuid)) { |json| sent_messages << json }

      Async do
        sender.send_message(message)
        sender.receive_reception_status(reception_status)
      end

      expect(sent_messages).to eq([message.to_json])
      expect(S2.logger).to have_received(:debug)
    end
  end

  describe "#cleanup" do
    it "stops all timeout tasks" do
      message = build(:s2_handshake)
      sender = described_class.new(resource_id: generate(:uuid)) do |_json|
        # omit sending
      end

      Async do |task|
        sender.send_message(message, timeout: 1) do |_|
          # empty callback
        end
        task.sleep 0.01
        expect(sender.timeout_tasks.size).to eq(1)
        sender.cleanup
        task.sleep 0.01
        expect(sender.timeout_tasks.size).to eq(0)
      end
    end
  end
end
