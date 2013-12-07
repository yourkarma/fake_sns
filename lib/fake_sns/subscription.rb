module FakeSNS
  class Subscription

    include Virtus.model

    attribute :arn, String
    attribute :protocol, String
    attribute :endpoint, String
    attribute :topic_arn, String
    attribute :owner, String

  end
end
