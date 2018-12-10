module FakeSNS
  module Actions
    class SetSubscriptionAttributes < Action
      VALID_PARAMETER_NAMES = %w[DeliveryPolicy RawMessageDelivery].freeze

      param key: 'AttributeName'
      param value: 'AttributeValue'
      param arn: 'SubscriptionArn'

      def call
        raise InvalidParameterValue, "AttributeName: #{key.inspect}" unless VALID_PARAMETER_NAMES.include?(key)
        subscription = db.subscriptions.fetch(arn)
        subscription[key] = value
      end
    end
  end
end
