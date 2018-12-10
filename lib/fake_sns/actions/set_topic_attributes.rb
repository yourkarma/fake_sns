module FakeSNS
  module Actions
    class SetTopicAttributes < Action
      VALID_PARAMETER_NAMES = %w[Policy DisplayName DeliveryPolicy].freeze

      param key:    'AttributeName'
      param value:  'AttributeValue'
      param arn:    'TopicArn'

      def call
        raise InvalidParameterValue, "AttributeName: #{key.inspect}" unless VALID_PARAMETER_NAMES.include?(key)
        topic = db.topics.fetch(arn) { raise NotFound, arn }
        topic[key] = value
      end
    end
  end
end
