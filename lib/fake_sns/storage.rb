require "yaml/store"

module FakeSNS

  class Storage

    def self.for(database_filename)
      if database_filename == ":memory:"
        MemoryStorage.new(database_filename)
      else
        FileStorage.new(database_filename)
      end
    end

    def initialize(database_filename)
      @database_filename = database_filename
    end

    def [](key)
      storage[key]
    end

    def []=(key, value)
      storage[key] = value
    end

  end

  class MemoryStorage < Storage

    def to_yaml
      storage.to_yaml
    end


    def storage
      @storage ||= {}
    end

    def transaction
      yield
    end

    def replace(data)
      @storage = YAML.load(data)
    end

  end

  class FileStorage < Storage

    def to_yaml
      storage["x"]
      storage.instance_variable_get(:@table).to_yaml
    end

    def storage
      @storage ||= YAML::Store.new(@database_filename)
    end

    def transaction
      storage.transaction do
        yield
      end
    end

    def replace(data)
      File.open(@database_filename, "w:utf-8") do |f|
        f.write(data)
      end
    end

  end

end
