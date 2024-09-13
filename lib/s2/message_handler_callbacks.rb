module S2
  module MessageHandlerCallbacks
    extend ActiveSupport::Concern

    included do
      class_attribute :on_open_proc, default: nil
      class_attribute :before_receive_proc, default: nil
      class_attribute :after_send_proc, default: nil
      class_attribute :on_close_proc, default: nil
    end

    class_methods do
      def on_open(&block)
        self.on_open_proc = block
      end

      def before_receive(&block)
        self.before_receive_proc = block
      end

      def after_send(&block)
        self.after_send_proc = block
      end

      def on_close(&block)
        self.on_close_proc = block
      end
    end

    protected

    def trigger_on_open(rm_id)
      instance_exec(rm_id, &self.class.on_open_proc) if self.class.on_open_proc
    end

    def trigger_before_receive(rm_id, message)
      instance_exec(rm_id, message, &self.class.before_receive_proc) if self.class.before_receive_proc
    end

    def trigger_after_send(rm_id, message)
      instance_exec(rm_id, message, &self.class.after_send_proc) if self.class.after_send_proc
    end

    def trigger_on_close(rm_id)
      instance_exec(rm_id, &self.class.on_close_proc) if self.class.on_close_proc
    end
  end
end
