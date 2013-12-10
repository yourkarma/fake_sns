require "spec_helper"

describe "Replacing the data" do

  it "works by submitting new YAML" do
    topic = sns.topics.create("my-topic")
    previous_data = $fake_sns.data.to_yaml
    apply_change = lambda { |data| data.gsub("my-topic", "your-topic") }
    new_data = apply_change.call(previous_data)
    $fake_sns.connection.put("/", new_data)
    expect(sns.topics.map(&:arn)).to eq [apply_change.call(topic.arn)]
  end

end
