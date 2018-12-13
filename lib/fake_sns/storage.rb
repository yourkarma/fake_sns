require 'yaml/store'

module FakeSNS
  # YAML Storage
  class Storage
    def self.for(database_filename)
      if database_filename == ':memory:'
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

  # In-memory data store
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
      @storage = YAML.safe_load(data)
    end
  end

  # Flat-file data store
  class FileStorage < Storage
    def to_yaml
      storage['x']
      storage.instance_variable_get(:@table).to_yaml
    end

    def storage
      @storage ||= YAML::Store.new(@database_filename)
    end

    def transaction
      storage.transaction do
        begin
          yield
        rescue StandardError
          storage.abort
        end
      end
    end

    def replace(data)
      File.open(@database_filename, 'w:utf-8') do |f|
        f.write(data)
      end
    end
  end
end
