module FakeSNS
  class PlatformEndpointCollection

    include Enumerable

    attr_reader :collection

    def initialize(store)
      @store = store
      @store["platform_endpoints"] ||= []
    end

    def collection
      @store["platform_endpoints"]
    end

    def reset
      @store["platform_endpoints"] = []
    end

    def each(*args, &block)
      collection.map { |item| PlatformEndpoint.new(item) }.each(*args, &block)
    end

    def create(attributes)
      collection << attributes
    end

    def delete(arn)
      collection.delete(fetch(arn))
    end

    def fetch(arn, &default)
      default ||= -> { raise InvalidParameterValue, "Unknown platform endpoint #{arn}" }
      found = collection.find do |platform_endpoint|
        platform_endpoint["arn"] == arn
      end
      found || default.call
    end

  end
end
