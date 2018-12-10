module FakeSNS
  # Subscription Collection
  class SubscriptionCollection
    include Enumerable

    def initialize(store)
      @store = store
      @store['subscriptions'] ||= []
    end

    def collection
      @store['subscriptions']
    end

    def reset
      @store['subscriptions'] = []
    end

    def each(*args, &block)
      collection.map { |item| Subscription.new(item) }.each(*args, &block)
    end

    def create(attributes)
      collection << attributes
    end

    def delete(arn)
      collection.delete(fetch(arn))
    end

    def fetch(arn, &default)
      default ||= lambda do
        raise InvalidParameterValue, "Unknown subscription #{arn}"
      end

      found = collection.find do |subscription|
        subscription['arn'] == arn
      end
      found || default.call
    end
  end
end
