require 'json'

module FakeSNS
  # Deserialized JSON attribute
  #
  # Really (Hash|string) where the value is just the raw
  # string if it cannot be parsed as JSON
  class JsonAttribute < Virtus::Attribute
    def coerce(value)
      value.is_a?(::Hash) ? value : JSON.parse(value)
    rescue StandardError
      value
    end
  end
end
