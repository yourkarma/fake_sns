module FakeSNS
  # Topic Collection
  class TopicCollection
    include Enumerable

    def initialize(store)
      @store = store
      @store['topics'] ||= []
    end

    def collection
      @store['topics']
    end

    def reset
      @store['topics'] = []
    end

    def each(*args, &block)
      collection.map { |item| Topic.new(item) }.each(*args, &block)
    end

    def fetch(arn, &default)
      default ||= -> { raise InvalidParameterValue, "Unknown topic #{arn}" }
      found = collection.find do |topic|
        topic['arn'] == arn
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
