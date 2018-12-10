RSpec.describe 'Publishing' do
  let(:existing_topic) { sns.create_topic(name: 'my-topic').topic_arn }

  it 'remembers published messages' do
    message_id = sns.publish(topic_arn: existing_topic, message: 'hallo').message_id
    messages = $fake_sns.data.fetch('messages')
    expect(messages.size).to eq 1
    message = messages.first
    expect(message.fetch(:id)).to eq message_id
  end

  it 'needs an existing topic' do
    non_existing = 'arn:aws:sns:us-east-1:5068edfd0f7ee3ea9ccc1e73cbb17569:not-exist'
    expect do
      sns.publish(topic_arn: non_existing, message: 'hallo')
    end.to raise_error Aws::SNS::Errors::InvalidParameterValue
  end

  it "doesn't allow messages that are too big" do
    expect do
      sns.publish(topic_arn: existing_topic, message: 'A' * 262_145)
    end.to raise_error Aws::SNS::Errors::InvalidParameterValue
  end
end
