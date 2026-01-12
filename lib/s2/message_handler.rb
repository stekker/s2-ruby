class S2::MessageHandler
  include ActiveSupport::Callbacks
  include Asserting
  include Dispatching
  include ErrorHandling
  include Replying

  define_callbacks :handle
  reply_with :@message_sender

  STATUSES = [
    :websocket_connected,
    :initialized,
  ].freeze

  class << self
    def before_handle(method_name = nil, &blk)
      set_callback :handle, :before, method_name || wrap_callback_block(blk)
    end

    def after_handle(method_name = nil, &blk)
      set_callback :handle, :after, method_name || wrap_callback_block(blk)
    end

    def around_handle(&)
      set_callback :handle, :around do |_, inner|
        instance_exec(Fiber[:s2_payload], -> { inner.call }, &)
      end
    end

    private

    def wrap_callback_block(blk)
      raise ArgumentError, "block required" unless blk

      proc do
        instance_exec(Fiber[:s2_payload], &blk)
      end
    end
  end

  attr_reader :state

  def initialize(message_sender:, state: { status: :websocket_connected })
    @message_sender = message_sender
    @state = state
  end

  def handle_message(payload)
    Fiber[:s2_payload] = payload

    run_callbacks :handle do
      message = S2::MessageFactory.create_message(payload)
      dispatch_message(message)
    end
  rescue StandardError => e
    rescue_with_handler(e) || raise
  end

  protected

  def update_state(**kwargs)
    @state.merge!(kwargs)
  end

  def update_status(new_status)
    raise ArgumentError, "Invalid status: #{new_status}" unless STATUSES.include?(new_status)

    update_state status: new_status
  end
end
