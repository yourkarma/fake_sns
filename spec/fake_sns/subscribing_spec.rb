RSpec.describe "Subscribing", :sqs do

  it "lists subscriptions globally" do
    topic_arn = sns.create_topic(name: "my-topic").topic_arn
    subscription_arn = sns.subscribe(topic_arn: topic_arn, protocol: "http", endpoint: "http://example.com").subscription_arn

    subscriptions = sns.list_subscriptions.subscriptions
    expect(subscriptions.map(&:topic_arn)).to eq [topic_arn]
    expect(subscriptions.map(&:subscription_arn)).to eq [subscription_arn]
  end

  it "filters by topic" do
    topic_arn = sns.create_topic(name: "my-topic").topic_arn
    _other_topic_arn = sns.create_topic(name: "my-topic-2").topic_arn

    subscription_arn = sns.subscribe(topic_arn: topic_arn, protocol: "http", endpoint: "http://example.com").subscription_arn
    subscriptions = sns.list_subscriptions.subscriptions
    expect(subscriptions.map(&:topic_arn)).to eq [topic_arn]
    expect(subscriptions.map(&:subscription_arn)).to eq [subscription_arn]
  end

  it "needs an existing topic" do
    topic_arn = "arn:aws:sns:us-east-1:5068edfd0f7ee3ea9ccc1e73cbb17569:not-exist"
    expect {
      sns.subscribe(topic_arn: topic_arn, protocol: "http", endpoint: "http://example.com")
    }.to raise_error Aws::SNS::Errors::InvalidParameterValue
  end

  it "can subscribe to a SQS queue" do
    queue_url = sqs.create_queue(queue_name: "my-queue").queue_url
    queue_arn = sqs.get_queue_attributes(queue_url: queue_url, attribute_names: ["QueueArn"]).attributes.fetch("QueueArn")
    topic_arn = sns.create_topic(name: "my-topic").topic_arn
    sns.subscribe(topic_arn: topic_arn, protocol: "sqs", endpoint: queue_arn)
  end

  it "won't subscribe twice to the same endpoint" do
    queue_url = sqs.create_queue(queue_name: "my-queue").queue_url
    queue_arn = sqs.get_queue_attributes(queue_url: queue_url, attribute_names: ["QueueArn"]).attributes.fetch("QueueArn")
    topic_arn = sns.create_topic(name: "my-topic").topic_arn

    2.times do
      sns.subscribe(topic_arn: topic_arn, protocol: "sqs", endpoint: queue_arn)
    end

    subscriptions = sns.list_subscriptions.subscriptions
    expect(subscriptions.size).to eq 1
  end

end
