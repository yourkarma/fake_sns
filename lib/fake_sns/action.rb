module FakeSNS
  class Action

    attr_reader :db, :params

    def self.param(fields, &block)
      fields.each do |field, key|
        define_method field do
          params.fetch(key, &block)
        end
      end
    end

    def initialize(db, params)
      @db = db
      @params = params
    end

    def call
      # override me, if needed
    end

  end
end
