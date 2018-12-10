module FakeSNS
  module Actions
    class ListTopics < Action
      def each_topic
        db.topics.each do |topic|
          yield topic
        end
      end
    end
  end
end
