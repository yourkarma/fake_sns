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
      'Number' => Numeric,
      'String' => String
    }.freeze

    def initialize(rules)
      @rules = rules
    end

    def passes?(message)
      return false unless message.respond_to?(:attrs)
      return false unless fields_match?(message.attrs)
      return false unless contains_values?(message.attrs)
      true
    end

    def fields_match?(attrs)
      attrs.keys == rules.keys
    end

    def contains_values?(attrs)
      attrs.all? do |prop, value|
        rules[prop].include?(value['Value'])
      end
    end
  end
end
