module FakeSNS
  # Represents a basic filter policy
  #
  # Only supports the very basic matching - i.e only
  # scalar + exact-match values.
  #
  # Until the need arises, we won't add the more complex
  # matching.
  class Filter
    attr_reader :rules

    TYPES = {
      'String' => String,
      'Number' => Numeric
    }.freeze

    def initialize(rules)
      @rules = rules
    end

    def passes?(message)
      return false unless message.respond_to?(:message)
      content = message.message
      rules.all? do |field, rule|
        return false if content[field].nil?
        return false unless passes_type?(content, field, rule['Type'])
        passes_value?(content, field, rule['Value'])
      end
    end

    def passes_type?(content, field, type)
      return false if TYPES[type].nil?
      content[field].is_a? TYPES[type]
    end

    def passes_value?(content, field, value)
      content[field] == value
    end
  end
end
