require 'forwardable'
require 'faraday'

module FakeSNS
  # Delivers messages to the correct target
  class DeliverMessage
    extend Forwardable

    def self.call(options)
      new(options).call
    end

    attr_reader :subscription, :message, :config, :request

    def_delegators :subscription, :protocol, :endpoint, :arn

    def initialize(options)
      @subscription = options.fetch(:subscription)
      @message = options.fetch(:message)
      @request = options.fetch(:request)
      @config = options.fetch(:config)
    end

    def call
      method_name = protocol.tr('-', '_')

      unless protected_methods.map(&:to_s).include?(method_name)
        raise InvalidParameterValue, "Protocol #{protocol} not supported"
      end

      send(method_name)
    end

    protected

    def sqs
      queue_name = endpoint.split(':').last
      sqs = Aws::SQS::Client.new(
        region: config.fetch('region'),
        credentials: Aws::Credentials.new(config.fetch('access_key_id'), config.fetch('secret_access_key'))
      ).tap do |client|
        client.config.endpoint = URI(config.fetch('sqs_endpoint'))
      end
      queue_url = sqs.get_queue_url(queue_name: queue_name).queue_url
      sqs.send_message(queue_url: queue_url, message_body: message_contents)
    end

    def http
      http_or_https
    end

    def https
      http_or_https
    end

    def email
      pending
    end

    def email_json
      pending
    end

    def sms
      pending
    end

    def application
      pending
    end

    private

    def message_contents
      message.message_for_protocol protocol
    end

    def pending
      puts "Not sending to subscription #{arn}, because protocol #{protocol} has no fake implementation. Message: #{message.id} - #{message_contents.inspect}"
    end

    def http_or_https
      Faraday.new.post(endpoint) do |f|
        f.body = {
          'Type'             => 'Notification',
          'MessageId'        => message.id,
          'TopicArn'         => message.topic_arn,
          'Subject'          => message.subject,
          'Message'          => message_contents,
          'Timestamp'        => message.received_at.strftime('%Y-%m-%dT%H:%M:%SZ'),
          'SignatureVersion' => '1',
          'Signature'        => 'Fake',
          'SigningCertURL'   => 'https://sns.us-east-1.amazonaws.com/SimpleNotificationService-f3ecfb7224c7233fe7bb5f59f96de52f.pem',
          'UnsubscribeURL'   => '', # TODO: url to unsubscribe URL on this server
        }.to_json
        f.headers = {
          'x-amz-sns-message-type'     => 'Notification',
          'x-amz-sns-message-id'       => message.id,
          'x-amz-sns-topic-arn'        => message.topic_arn,
          'x-amz-sns-subscription-arn' => arn
        }
      end
    end
  end
end
