module FakeSNS
  class MessageCollection

    include Enumerable

    def initialize(store)
      @store = store
      @store["messages"] ||= []
    end

    def collection
      @store["messages"]
    end

    def reset
      @store["messages"] = []
    end

    def each(*args, &block)
      collection.map { |item| Message.new(item) }.each(*args, &block)
    end

    def fetch(arn, &default)
      default ||= -> { raise InvalidParameterValue, "Unknown message #{arn}" }
      found = collection.find do |message|
        message["arn"] == arn
      end
      found || default.call
    end

    def create(attributes)
      collection << attributes
    end

    def delete(arn)
      collection.delete(fetch(arn))
    end

  end
end
