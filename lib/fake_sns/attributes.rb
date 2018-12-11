require 'json'

module FakeSNS
  # Filters out and restructures subscription attributes
  # so that they can be accessed as a tradional hash
  class Attributes
    attr_reader :params

    def initialize(params)
      @params = params
    end

    def entries
      params.keys.count { |key| key =~ /Attributes.entry.\d+/ } / 2
    end

    def raw
      (1..entries).map do |n|
        prefix = "Attributes.entry.#{n}"
        [params.fetch("#{prefix}.key"), params.fetch("#{prefix}.value")]
      end.to_h
    end

    def [](key)
      JSON.parse(raw[key])
    rescue JSON::ParseError
      raw[key]
    end

    def fetch(key, default)
      return default if self[key].nil?
      self[key]
    end
  end
end
