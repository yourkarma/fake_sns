module FakeSNS
  module Actions
    class DeleteTopic < Action

      param arn: "TopicArn"

      def call
        db.topics.delete(arn)
      end

    end
  end
end
