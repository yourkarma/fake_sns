require "spec_helper"

describe "Subscribing", :sqs do

  it "lists subscriptions globally" do
    topic = sns.topics.create("my-topic")
    subscription = topic.subscribe("http://example.com")
    expect(sns.subscriptions.map(&:topic_arn)).to eq [topic.arn]
    expect(sns.subscriptions.map(&:arn)).to eq [subscription.arn]
  end

  it "filters by topic" do
    topic = sns.topics.create("my-topic")
    other_topic = sns.topics.create("my-topic-2")
    subscription = topic.subscribe("http://example.com")
    expect(topic.subscriptions.map(&:topic_arn)).to eq [topic.arn]
    expect(topic.subscriptions.map(&:arn)).to eq [subscription.arn]
    expect(other_topic.subscriptions.map(&:arn)).to eq []
  end

  it "needs an existing topic" do
    topic = sns.topics["arn:aws:sns:us-east-1:5068edfd0f7ee3ea9ccc1e73cbb17569:not-exist"]
    expect {
      topic.subscribe("http://example.com")
    }.to raise_error AWS::SNS::Errors::InvalidParameterValue
  end

  it "can subscribe to a SQS queue" do
    queue = AWS::SQS.new.queues.create("my-queue")
    topic = sns.topics.create("my-topic")
    topic.subscribe(queue)
  end

end
