module FakeSNS
  class SubscriptionCollection

    include Enumerable

    attr_reader :collection

    def initialize(store)
      @store = store
      @store["subscriptions"] ||= []
    end

    def collection
      @store["subscriptions"]
    end

    def reset
      @store["subscriptions"] = []
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

  end
end
