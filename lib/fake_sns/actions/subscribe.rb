module FakeSNS
  module Actions
    # Subscribe SNS action
    class Subscribe < Action
      param endpoint: 'Endpoint'
      param protocol: 'Protocol'
      param topic_arn: 'TopicArn'

      attr_reader :topic

      def call
        @topic = db.topics.fetch(topic_arn) do
          raise InvalidParameterValue, "Unknown topic: #{topic_arn}"
        end
        @subscription = (existing_subscription || new_subscription)
      end

      def subscription_arn
        @subscription['arn']
      end

      private

      def existing_subscription
        db.subscriptions.to_a.find do |s|
          s.topic_arn == topic_arn && s.endpoint == endpoint
        end
      end

      def new_subscription
        message_attributes = Attributes.new(params)

        attributes = {
          'arn'       => "#{topic_arn}:#{SecureRandom.uuid}",
          'protocol'  => protocol,
          'endpoint'  => endpoint,
          'topic_arn' => topic_arn,
          'filter' => message_attributes.fetch('FilterPolicy', {})
        }

        db.subscriptions.create(attributes)
        attributes
      end
    end
  end
end
