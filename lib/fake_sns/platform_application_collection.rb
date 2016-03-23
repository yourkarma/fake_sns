module FakeSNS
  class PlatformApplicationCollection

    include Enumerable

    attr_reader :collection

    def initialize(store)
      @store = store
      @store["platform_applications"] ||= []
    end

    def collection
      @store["platform_applications"]
    end

    def reset
      @store["platform_applications"] = []
    end

    def each(*args, &block)
      collection.map { |item| PlatformApplication.new(item) }.each(*args, &block)
    end

    def create(attributes)
      collection << attributes
    end

    def delete(arn)
      collection.delete(fetch(arn))
    end

    def fetch(arn, &default)
      default ||= -> { raise InvalidParameterValue, "Unknown platform application #{arn}" }
      found = collection.find do |platform_application|
        platform_application["arn"] == arn
      end
      found || default.call
    end

  end
end
