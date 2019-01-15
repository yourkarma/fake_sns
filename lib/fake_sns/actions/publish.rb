module FakeSNS
  module Actions
    # Publish action
    class Publish < Action
      param message: 'Message'
      param message_structure: 'MessageStructure' do nil end
      param subject: 'Subject' do nil end
      param target_arn: 'TargetArn' do nil end
      param topic_arn: 'TopicArn' do nil end

      def call
        guard_message_size
        fetch_topic
        generate_id

        db.messages.create(
          id:          message_id,
          subject:     subject,
          message:     message,
          topic_arn:   topic_arn,
          structure:   message_structure,
          target_arn:  target_arn,
          received_at: Time.now,
          attrs:  attrs
        )
      end

      def message_id
        @message_id || raise(InternalFailure, 'no message id yet, this should not happen')
      end

      private

      def attrs
        MessageAttributes.new(params).get
      end

      def fetch_topic
        @topic = db.topics.fetch(topic_arn) do
          raise InvalidParameterValue, "Unknown topic: #{topic_arn}"
        end
      end

      def generate_id
        @message_id = SecureRandom.uuid
      end

      def guard_message_size
        return unless (bytes = message.bytesize) > 262_144
        raise InvalidParameterValue, "Too much bytes: #{bytes} > 262144."
      end
    end
  end
end
