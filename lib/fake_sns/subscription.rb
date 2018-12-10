module FakeSNS
  # Subscription Model
  class Subscription
    include Virtus.model

    attribute :arn, String
    attribute :protocol, String
    attribute :endpoint, String
    attribute :topic_arn, String
    attribute :owner, String
    attribute :delivery_policy, String
    attribute :raw_message_delivery, Boolean

    def sqs?
      protocol == 'sqs'
    end
  end
end
