module FakeSNS
  module Actions
    class GetTopicAttributes < Action
      param arn: 'TopicArn'

      # TopicArn
      # Owner
      # Policy
      # DisplayName
      # SubscriptionsPending
      # SubscriptionsConfirmed
      # SubscriptionsDeleted
      # DeliveryPolicy
      # EffectiveDeliveryPolicy

      attr_reader :topic

      def call
        @topic = db.topics.fetch(arn) { raise NotFound, arn }
      end

      def each_attribute
        yield 'TopicArn', arn
        %w[DisplayName Policy DeliveryPolicy].each do |key|
          yield key, topic[key] if topic.key?(key)
        end
      end
    end
  end
end
