RSpec.describe "Topics" do

  it "rejects invalid characters in topic names" do
    expect {
      sns.create_topic(name: "dot.dot")
    }.to raise_error(Aws::SNS::Errors::InvalidParameterValue)
  end

  it "creates a new topic" do
    topic_arn = sns.create_topic(name: "my-topic").topic_arn
    expect(topic_arn).to match(/arn:aws:sns:us-east-1:(\w+):my-topic/)

    new_topic_arn = sns.create_topic(name: "other-topic").topic_arn
    expect(new_topic_arn).not_to eq topic_arn

    existing_topic_arn = sns.create_topic(name: "my-topic").topic_arn
    expect(existing_topic_arn).to eq topic_arn
  end

  it "lists topics" do
    topic1_arn = sns.create_topic(name: "my-topic-1").topic_arn
    topic2_arn = sns.create_topic(name: "my-topic-2").topic_arn

    expect(sns.list_topics.topics.map(&:topic_arn)).to match_array [topic1_arn, topic2_arn]
  end

  it "deletes topics" do
    topic_arn = sns.create_topic(name: "my-topic").topic_arn
    expect(sns.list_topics.topics.map(&:topic_arn)).to eq [topic_arn]
    sns.delete_topic(topic_arn: topic_arn)
    expect(sns.list_topics.topics.map(&:topic_arn)).to eq []
  end

  it "can set and read attributes" do
    topic_arn = sns.create_topic(name: "my-topic").topic_arn
    expect(sns.get_topic_attributes(topic_arn: topic_arn).attributes["DisplayName"]).to eq nil

    sns.set_topic_attributes(topic_arn: topic_arn, attribute_name: "DisplayName", attribute_value: "the display name")
    expect(sns.get_topic_attributes(topic_arn: topic_arn).attributes["DisplayName"]).to eq "the display name"
  end

end
