require "spec_helper"

describe "Publishing" do

  let(:existing_topic) { sns.topics.create("my-topic") }

  it "publishes something" do
    existing_topic.publish("hallo")
  end

  it "needs an existing topic" do
    topic = sns.topics["arn:aws:sns:us-east-1:5068edfd0f7ee3ea9ccc1e73cbb17569:not-exist"]
    expect {
      topic.publish("hallo")
    }.to raise_error AWS::SNS::Errors::InvalidParameterValue
  end

  it "doesn't allow messages that are too big" do
    expect {
      existing_topic.publish("A" * 262145)
    }.to raise_error AWS::SNS::Errors::InvalidParameterValue
  end

end
