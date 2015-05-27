require "json"

module FakeSNS
  class Message

    include Virtus.model

    json = Class.new(Virtus::Attribute) do
      def coerce(value)
        value.is_a?(::Hash) ? value : JSON.parse(value)
      rescue
        value
      end
    end

    attribute :id, String
    attribute :subject, String
    attribute :endpoint, String
    attribute :topic_arn, String
    attribute :structure, String
    attribute :target_arn, String
    attribute :received_at, DateTime
    attribute :message, json

    def message_for_protocol(type)
      message.fetch(type.to_s) { message.fetch("default") }
    end

  end
end
