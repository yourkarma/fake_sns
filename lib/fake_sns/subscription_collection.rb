module FakeSNS
  class SubscriptionCollection

    include Enumerable

    attr_reader :collection

    def initialize(collection)
      @collection = collection
      @collection ||= []
    end

    def reset
      @collection = []
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
