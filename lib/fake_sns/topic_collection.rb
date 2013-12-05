module FakeSNS
  class TopicCollection

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
      collection.each(*args, &block)
    end

    def fetch(arn, &default)
      default ||= -> { raise InvalidParameterValue, "Unknown topic #{arn}" }
      found = collection.find do |topic|
        topic["arn"] == arn
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
