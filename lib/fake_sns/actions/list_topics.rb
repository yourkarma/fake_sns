module FakeSNS
  module Actions
    class ListTopics < Action

      def each_topic
        db.topics.each do |topic|
          yield Struct.new(:arn).new(topic["arn"])
        end
      end

    end
  end
end
