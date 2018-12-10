require_relative 'list_subscriptions'

module FakeSNS
  module Actions
    class ListSubscriptionsByTopic < ListSubscriptions
      param topic_arn: 'TopicArn'
      param next_token: 'NextToken'

      def call
        super
        @topic = db.topics.fetch(topic_arn) do
          raise InvalidParameterValue, "Unknown topic: #{topic_arn}"
        end
      end

      private

      def subscriptions
        super.select { |s| s['topic_arn'] == topic_arn }
      end
    end
  end
end
