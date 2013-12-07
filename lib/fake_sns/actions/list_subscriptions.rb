module FakeSNS
  module Actions
    class ListSubscriptions < Action

      param next_token: "NextToken"

      def call
      end

      def each_subscription
        subscriptions.each do |subscription|
          yield subscription
        end
      end

      private

      def subscriptions
        db.subscriptions
      end

    end
  end
end
