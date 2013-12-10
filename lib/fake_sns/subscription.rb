module FakeSNS
  class Subscription

    include Virtus.model

    attribute :arn, String
    attribute :protocol, String
    attribute :endpoint, String
    attribute :topic_arn, String
    attribute :owner, String

    def sqs?
      protocol == "sqs"
    end

    def deliver(message, options)
      send(protocol.gsub("-", "_"), message, options)
    end

    private

    def sqs(message, options)
      msg = message.message_for_protocol("sqs")
      queue_name = endpoint.split(":").last

      sqs = AWS::SQS.new(options["aws_config"] || {})
      queue = sqs.queues.named(queue_name)
      queue.send_message(msg)
    end

    def http(message, *)
      http_or_https "http", message
    end

    def https(message, *)
      http_or_https "https", message
    end

    def email(message, *)
      not_sending(message)
    end

    def email_json(message, *)
      not_sending(message)
    end

    def sms(message, *)
      not_sending(message)
    end

    def application(message, *)
      not_sending(message)
    end

    def not_sending(message)
      puts "Not sending subscription #{arn}, because protocol #{protocol} has no fake implementation. Message: #{message.id} - #{message.message_for_protocol(protocol).inspect}"
    end

    def http_or_https(type, message)
      Faraday.new.post(endpoint) do |f|
        f.body = {
          "Type" => "Notification",
          "MessageId" => message.id,
          "TopicArn" => message.topic_arn,
          "Subject" => message.subject,
          "Message" => message.message_for_protocol(type),
          "Timestamp" => message.received_at.strftime("%Y-%m-%dT%H:%M:%SZ"),
          "SignatureVersion" => "1",
          "Signature" => "Fake",
          "SigningCertURL" => "https://sns.us-east-1.amazonaws.com/SimpleNotificationService-f3ecfb7224c7233fe7bb5f59f96de52f.pem",
          "UnsubscribeURL" => "", # TODO url to unsubscribe URL on this server
        }.to_json
        f.headers = {
          "x-amz-sns-message-type" => "Notification",
          "x-amz-sns-message-id" => message.id,
          "x-amz-sns-topic-arn" => message.topic_arn,
          "x-amz-sns-subscription-arn" => arn,
        }
      end
    end

    # There is no API to get the URL for a queue by the ARN, so we assume the
    # queue's name from the ARN.
    def queue_name
    end

  end
end
