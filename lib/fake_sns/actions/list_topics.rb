module FakeSNS
  module Actions
    class ListTopics < Action

      def each_topic
        db.topics.each do |arn, topic|
          yield Struct.new(:arn).new(arn)
        end
      end

    end
  end
end
