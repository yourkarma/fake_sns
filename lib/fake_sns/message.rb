module FakeSNS
  # Message model
  class Message
    include Virtus.model

    attribute :id, String
    attribute :subject, String
    attribute :endpoint, String
    attribute :topic_arn, String
    attribute :structure, String
    attribute :target_arn, String
    attribute :received_at, DateTime
    attribute :message, JsonAttribute

    def message_for_protocol(type)
      return message if message.is_a?(String)
      return message unless message.key?(type.to_s) || message.key?('default')
      message.fetch(type.to_s) { message.fetch('default') }
    end

    def raw_message
      return message if message.is_a?(String)
      message.to_json
    end

    def for?(subscription, topic)
      return false unless topic_arn == topic.arn
      return false unless topic_arn == subscription.topic_arn
      subscription.accepts?(self)
    end

    def timestamp
      received_at.strftime('%Y-%m-%dT%H:%M:%SZ')
    end

    def type
      'Notification'
    end

    def signature
      Signature.new(self).sign
    end
  end
end
