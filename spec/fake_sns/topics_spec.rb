require "spec_helper"

describe "CreateTopic" do

  it "rejects invalid characters in topic names" do
    expect {
      sns.topics.create("dot.dot")
    }.to raise_error(AWS::SNS::Errors::InvalidParameterValue)
  end

  it "creates a new topic" do
    topic = sns.topics.create("my-topic")
    expect(topic.arn).to match(/arn:aws:sns:us-east-1:(\w+):my-topic/)

    new_topic = sns.topics.create("other-topic")
    expect(new_topic.arn).not_to eq topic.arn

    existing_topic = sns.topics.create("my-topic")
    expect(existing_topic.arn).to eq topic.arn
  end

  it "lists topics" do
    topic1 = sns.topics.create("my-topic-1")
    topic2 = sns.topics.create("my-topic-2")

    expect(sns.topics.map(&:arn)).to match_array [topic1.arn, topic2.arn]
  end

end
