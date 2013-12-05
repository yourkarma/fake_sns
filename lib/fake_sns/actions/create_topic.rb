module FakeSNS
  module Actions
    class CreateTopic < Action

      param name: "Name"

      def valid_name?
        name =~ /\A[\w\-]+\z/
      end

      def call
        raise InvalidParameterValue, "Topic Name: #{name.inspect}" unless valid_name?
        @topic = (existing_topic || new_topic)
      end

      def arn
        topic["arn"]
      end

      attr_reader :topic

      private

      def new_topic
        arn = generate_arn
        topic_attributes = { "arn" => arn, "name" => name }
        db.topics.create(topic_attributes)
        topic_attributes
      end

      def generate_arn
        "arn:aws:sns:us-east-1:#{SecureRandom.hex}:#{name}"
      end

      def existing_topic
        db.topics.find { |t| t["name"] == name }
      end

    end
  end
end
