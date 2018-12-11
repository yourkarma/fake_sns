module FakeSNS
  # Action base class
  class Action
    attr_reader :db, :params

    def self.param(fields, &block)
      fields.each do |field, key|
        define_method field do
          params.fetch(key, &block)
        end
      end
    end

    def initialize(database, params)
      @db = database
      @params = params
    end

    def call
      # override me, if needed
    end
  end
end
