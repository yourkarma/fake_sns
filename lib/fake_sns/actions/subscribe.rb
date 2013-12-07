module FakeSNS
  module Actions
    class Subscribe < Action

      param endpoint: "Endpoint"
      param protocol: "Protocol"
      param topic_arn: "TopicArn"

      attr_reader :topic

      def call
        @topic = db.topics.fetch(topic_arn) do
          raise InvalidParameterValue, "Unknown topic: #{topic_arn}"
        end
        db.subscriptions.create(
          "arn"       => subscription_arn,
          "protocol"  => protocol,
          "endpoint"  => endpoint,
          "topic_arn" => topic_arn,
        )
      end

      def subscription_arn
        "#{topic_arn}:#{subscription_id}"
      end

      def subscription_id
        @subscription_id ||= SecureRandom.uuid
      end

    end
  end
end
