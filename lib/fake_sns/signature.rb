require 'openssl'

module FakeSNS
  # Represents a signature for an SNS message.
  class Signature
    KEYS = {
      raw_message: 'Message',
      id: 'MessageId',
      subject: 'Subject',
      timestamp: 'Timestamp',
      topic_arn: 'TopicArn',
      type: 'Type'
    }.freeze

    attr_reader :message

    def initialize(message)
      @message = message
    end

    def document_lines
      lines = KEYS.map do |prop, header|
        [header, message[prop]]
      end

      lines.reject do |_, value|
        value.nil?
      end.flatten
    end

    def document
      document_lines.join("\n") << "\n"
    end

    def key
      key_contents = File.read('keys/private.pem')
      OpenSSL::PKey::RSA.new(key_contents)
    end

    def sign
      digest = OpenSSL::Digest::SHA1.new
      key.sign(digest, document)
    end
  end
end
