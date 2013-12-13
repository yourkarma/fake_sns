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
        @subscription = (existing_subscription || new_subscription)
      end

      def subscription_arn
        if @subscription
          @subscription.arn
        else
          raise InvalidParameterValue, "HELP"
        end
      end

      private

      def existing_subscription
        db.subscriptions.find { |s|
          s.topic_arn == topic_arn && s.endpoint == endpoint
        }
      end

      def new_subscription
        db.subscriptions.create(
          "arn"       => "#{topic_arn}:#{SecureRandom.uuid}",
          "protocol"  => protocol,
          "endpoint"  => endpoint,
          "topic_arn" => topic_arn,
        )
        existing_subscription
      end

    end
  end
end
