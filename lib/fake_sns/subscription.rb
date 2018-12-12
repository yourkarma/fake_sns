require 'pp'

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
    attribute :filter, JsonAttribute

    def sqs?
      protocol == 'sqs'
    end

    def accepts?(message)
      Filter.new(filter).passes?(message)
    end
  end
end
