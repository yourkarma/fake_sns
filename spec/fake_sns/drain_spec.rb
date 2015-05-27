require "sinatra/base"
require 'json_expressions/rspec'

RSpec.describe "Drain messages", :sqs do

  it "works for SQS" do
    queue_url = sqs.create_queue(queue_name: "my-queue").queue_url
    queue_arn = sqs.get_queue_attributes(queue_url: queue_url, attribute_names: ["QueueArn"]).attributes.fetch("QueueArn")
    topic_arn = sns.create_topic(name: "my-topic").topic_arn

    _subscription_arn = sns.subscribe(topic_arn: topic_arn, protocol: "sqs", endpoint: queue_arn).subscription_arn

    sns.publish(topic_arn: topic_arn, message: { sqs: "hallo" }.to_json)

    $fake_sns.drain(nil, sqs_endpoint: sqs.config.endpoint.to_s)

    attributes = sqs.get_queue_attributes(queue_url: queue_url, attribute_names: ["ApproximateNumberOfMessages"]).attributes
    expect(attributes.fetch("ApproximateNumberOfMessages")).to eq "1"
  end

  it "works for SQS with a single message" do

    queue_url = sqs.create_queue(queue_name: "my-queue").queue_url
    queue_arn = sqs.get_queue_attributes(queue_url: queue_url, attribute_names: ["QueueArn"]).attributes.fetch("QueueArn")
    topic_arn = sns.create_topic(name: "my-topic").topic_arn

    _subscription_arn = sns.subscribe(topic_arn: topic_arn, protocol: "sqs", endpoint: queue_arn).subscription_arn

    message_id = sns.publish(topic_arn: topic_arn, message: { sqs: "hallo" }.to_json).message_id
    sns.publish(topic_arn: topic_arn, message: { sqs: "world" }.to_json)

    $fake_sns.drain(message_id, sqs_endpoint: sqs.config.endpoint.to_s)

    attributes = sqs.get_queue_attributes(queue_url: queue_url, attribute_names: ["ApproximateNumberOfMessages"]).attributes
    expect(attributes.fetch("ApproximateNumberOfMessages")).to eq "1"
  end

  it "works for HTTP" do
    requests = []
    _headers = []
    target_app = Class.new(Sinatra::Base) do
      get("/") { 200 } # check if server started
      post("/endpoint") do
        requests << request.body.read
        _headers << request.env
        200
      end
    end

    app_runner = Thread.new do
      target_app.set :port, 5051
      target_app.run!
    end

    topic_arn = sns.create_topic(name: "my-topic").topic_arn

    subscription_arn = sns.subscribe(topic_arn: topic_arn, protocol: "http", endpoint: "http://localhost:5051/endpoint").subscription_arn

    message_id = sns.publish(topic_arn: topic_arn, message: { default: "hallo" }.to_json).message_id

    wait_for { Faraday.new("http://localhost:5051").get("/").success? rescue false }

    $fake_sns.drain(nil, sqs_endpoint: sqs.config.endpoint.to_s)

    app_runner.kill

    expect(requests.size).to eq 1
    expect(requests.first).to match_json_expression(
      "Type"             => "Notification",
      "Message"          => "hallo",
      "MessageId"        => message_id,
      "Signature"        => "Fake",
      "SignatureVersion" => "1",
      "SigningCertURL"   => "https://sns.us-east-1.amazonaws.com/SimpleNotificationService-f3ecfb7224c7233fe7bb5f59f96de52f.pem",
      "Subject"          => nil,
      "Timestamp"        => anything,
      "TopicArn"         => topic_arn,
      "Type"             => "Notification",
      "UnsubscribeURL"   => "",
    )

    expect(_headers.size).to eq 1
    expect(_headers.first).to match_json_expression({
      "HTTP_X_AMZ_SNS_MESSAGE_TYPE"     => "Notification",
      "HTTP_X_AMZ_SNS_MESSAGE_ID"       => message_id,
      "HTTP_X_AMZ_SNS_TOPIC_ARN"        => topic_arn,
      "HTTP_X_AMZ_SNS_SUBSCRIPTION_ARN" => subscription_arn,
    }.ignore_extra_keys!)

  end

  def wait_for(&condition)
    Timeout.timeout 1 do
      until condition.call
        sleep 0.01
      end
    end
  end

end
