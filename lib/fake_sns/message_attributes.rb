module FakeSNS
  # Parses SNS message attributes
  # Credit: https://github.com/localstack/localstack/blob/master/localstack/services/sns/sns_listener.py#L254
  class MessageAttributes
    attr_reader :params

    def initialize(params)
      @params = params
    end

    def get
      attributes = {}
      x = 1
      loop do
        name = params.fetch(prefix(x, 'Name'), nil)
        break if name.nil?
        attributes[name] = {
          'Type' => type(x),
          'Value' => value(x)
        }
        x += 1
      end
      attributes
    end

    private

    def type(x)
      params.fetch(prefix(x, 'Value.DataType'), nil)
    end

    def value(x)
      str_value = params.fetch(prefix(x, 'Value.StringValue'), nil)
      bin_value = params.fetch(prefix(x, 'Value.BinaryValue'), nil)
      return str_value unless str_value.nil?
      bin_value
    end

    def prefix(x, key)
      'MessageAttributes.entry.' + x.to_s + '.' + key.to_s
    end
  end
end
