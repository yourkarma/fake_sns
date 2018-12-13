module FakeSNS
  # DB messages collection
  class MessageCollection
    include Enumerable

    def initialize(store)
      @store = store
      @store['messages'] ||= []
    end

    def collection
      @store['messages']
    end

    def reset
      @store['messages'] = []
    end

    def each(*args, &block)
      collection.map { |item| Message.new(item) }.each(*args, &block)
    end

    def fetch(id, &default)
      default ||= -> { raise InvalidParameterValue, "Unknown message #{arn}" }
      found = collection.find do |message|
        message[:id] == id
      end
      found || default.call
    end

    def create(attributes)
      collection << attributes
    end

    def delete(id)
      collection.delete(fetch(id))
    end
  end
end
