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
        topic = { "arn" => arn, "name" => name }
        db.topics[arn] = topic
        topic
      end

      def generate_arn
        "arn:aws:sns:us-east-1:#{SecureRandom.hex}:#{name}"
      end

      def existing_topic
        _, topic = db.topics.find do |arn, t|
          t["name"] == name
        end
        topic
      end

    end
  end
end
