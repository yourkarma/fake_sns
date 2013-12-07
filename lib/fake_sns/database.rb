require "etc"
require "yaml/store"

module FakeSNS
  class Database

    attr_reader :database_filename

    def initialize(database_filename)
      @database_filename = database_filename || File.join(Dir.home, ".fake_sns.yml")
    end

    def perform(action, params)
      action_instance = action_provider(action).new(self, params)
      action_instance.call
      Response.new(action_instance)
    end

    def topics
      @topics ||= TopicCollection.new(store["topics"])
    end

    def subscriptions
      @subscriptions ||= SubscriptionCollection.new(store["subscriptions"])
    end

    def reset
      topics.reset
      subscriptions.reset
    end

    def transaction
      if memory_store?
        yield
      else
        store.transaction do
          yield
        end
      end
    end

    private

    def store
      if memory_store?
        @store ||= {}
      else
        @store ||= YAML::Store.new(database_filename)
      end
    end

    def memory_store?
      database_filename == ":memory:"
    end

    def action_provider(action)
      Actions.const_get(action)
    rescue NameError
      raise InvalidAction, "not implemented: #{action}"
    end

  end
end
