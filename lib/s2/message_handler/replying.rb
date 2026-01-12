module S2::MessageHandler::Replying
  NULL_MESSAGE_ID = "00000000-0000-0000-0000-000000000000".freeze

  REPLY_STATUSES = {
    invalid_content: S2::Messages::ReceptionStatusValues::InvalidContent,
    invalid_data: S2::Messages::ReceptionStatusValues::InvalidData,
    invalid_message: S2::Messages::ReceptionStatusValues::InvalidMessage,
    ok: S2::Messages::ReceptionStatusValues::Ok,
    permanent_error: S2::Messages::ReceptionStatusValues::PermanentError,
    temporary_error: S2::Messages::ReceptionStatusValues::TemporaryError,
  }.freeze

  extend ActiveSupport::Concern

  included do
    class_attribute :replier, instance_accessor: false, default: nil
  end

  class_methods do
    protected

    def reply_with(name)
      self.replier = name
    end
  end

  def reply(to:, status:, diagnostic_label: nil)
    s2_status = REPLY_STATUSES.fetch(status) do
      raise ArgumentError, "Unknown status: #{status}"
    end

    reply_message = S2::Messages::ReceptionStatus.new(
      message_type: S2::Messages::ReceptionStatusMessageType::ReceptionStatus,
      subject_message_id: message_id_for(to),
      status: s2_status,
      diagnostic_label:,
    )

    send_message(reply_message)
  end

  def message_id_for(to)
    return to if to.is_a?(String)

    to&.message_id.presence || NULL_MESSAGE_ID
  end

  def reply_ok(to:)
    reply(to:, status: :ok)
  end

  protected # rubocop:disable Lint/UselessAccessModifier

  def replier
    raise "No replier configured" unless self.class.replier

    instance_variable_get(self.class.replier)
  end

  def send_message(message, &)
    replier.send_message(message, &)
  end
end
