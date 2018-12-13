require 'ostruct'
require 'openssl'

RSpec.describe "Signing", :signature do
  def message
    OpenStruct.new(
      raw_message: 'The message',
      id: 'The ID',
      subject: 'The subject',
      timestamp: 'The timestamp',
      topic_arn: 'The topic ARN',
      type: 'Notification'
    )
  end

  def document
    [
      'Message',
      'The message',
      'MessageId',
      'The ID',
      'Subject',
      'The subject',
      'Timestamp',
      'The timestamp',
      'TopicArn',
      'The topic ARN',
      'Type',
      'Notification',
      ''
    ].join("\n")
  end

  it "should generate the document to sign" do
    expect(signature(message).document).to eql document
  end

  it "should sign a message" do
    signed = signature(message).sign

    digest = OpenSSL::Digest::SHA1.new
    key = OpenSSL::PKey::RSA.new(File.read('keys/public.cer'))
    expect(key.verify(digest, signed, document)).to eql true
  end
end
