module FakeSNS
  module Actions
    class Publish < Action

      param message: "Message"
      param message_structure: "MessageStructure"
      param subject: "Subject"
      param target_arn: "TargetArn"
      param topic_arn: "TopicArn"

      def call
        if (bytes = message.bytesize) > 262144
          raise InvalidParameterValue, "Too much bytes: #{bytes} > 262144."
        end
        @topic = db.topics.fetch(topic_arn) do
          raise InvalidParameterValue, "Unknown topic: #{topic_arn}"
        end
        @message_id = SecureRandom.uuid
      end

      def message_id
        @message_id || raise(InternalFailure, "no message id yet, this should not happen")
      end

    end
  end
end
