module FakeSNS
  # Topic model
  class Topic
    include Virtus.model

    attribute :arn, String
    attribute :name, String
    attribute :policy, String
    attribute :display_name, String
    attribute :delivery_policy, String
  end
end
