RSpec.describe "Replacing the data" do

  it "works by submitting new YAML" do
    topic_arn = sns.create_topic(name: "my-topic").topic_arn
    previous_data = $fake_sns.data.to_yaml
    apply_change = lambda { |data| data.gsub("my-topic", "your-topic") }
    new_data = apply_change.call(previous_data)
    $fake_sns.connection.put("/", new_data)
    expect(sns.list_topics.topics.map(&:topic_arn)).to eq [apply_change.call(topic_arn)]
  end

end
