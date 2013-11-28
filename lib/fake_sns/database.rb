module FakeSNS
  class Database

    def perform(action, params)
      action = Actions.const_get(action).new(self, params)
      action.call
      Response.new(action)
    end

    def topics
      @topics ||= {}
    end

    def reset
      @topics = {}
    end

  end
end
