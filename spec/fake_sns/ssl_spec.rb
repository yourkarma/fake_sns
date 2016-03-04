RSpec.describe "SSL" do
  context "with SSL enabled" do
    before do
      sns.config.endpoint.scheme = "https"
    end

    after do
      sns.config.endpoint.scheme = "http"
    end

    it "lists topics" do
      topic1_arn = sns.create_topic(name: "my-topic-1").topic_arn
      topic2_arn = sns.create_topic(name: "my-topic-2").topic_arn

      expect(sns.list_topics.topics.map(&:topic_arn)).to match_array [topic1_arn, topic2_arn]
    end
  end

end
