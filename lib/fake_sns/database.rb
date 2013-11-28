module FakeSNS
  class Database

    def perform(action, params)
      action_instance = action_provider(action).new(self, params)
      action_instance.call
      Response.new(action_instance)
    end

    def topics
      @topics ||= {}
    end

    def reset
      @topics = {}
    end

    private

    def action_provider(action)
      Actions.const_get(action)
    rescue NameError
      raise InvalidAction, "not implemented: #{action}"
    end

  end
end
