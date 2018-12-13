ENV['RACK_ENV'] ||= 'test'

require 'bundler/setup'
Bundler.setup

require 'verbose_hash_fetch'
require 'aws-sdk'
require 'pry'
require 'fake_sns/test_integration'
require 'fake_sqs/test_integration'
require 'fake_sns/filter'
require 'fake_sns/signature'

Aws.config.update(
  region: 'us-east-1',
  credentials: Aws::Credentials.new('fake', 'fake')
)
# Aws.config(
#   use_ssl:            false,
#   sqs_endpoint:       "localhost",
#   sqs_port:           4568,
#   sns_endpoint:       "localhost",
#   sns_port:           9293,
#   access_key_id:      "fake access key",
#   secret_access_key:  "fake secret key",
# )

db = ENV['SNS_DATABASE']
db = ':memory:' if ENV['SNS_DATABASE'].to_s == ''

puts "Running tests with database stored in #{db}"

$fake_sns = FakeSNS::TestIntegration.new(
  database:      db,
  sns_endpoint:  'localhost',
  sns_port:      9293
)

$fake_sqs = FakeSQS::TestIntegration.new(
  database:      ':memory:',
  sqs_endpoint:  'localhost',
  sqs_port:      4568
)

module SpecHelper
  def sns
    Aws::SNS::Client.new.tap do |client|
      client.config.endpoint = URI('http://localhost:9293')
    end
  end

  def sqs
    Aws::SQS::Client.new.tap do |client|
      client.config.endpoint = URI('http://localhost:4568')
    end
  end

  def filter(rules)
    FakeSNS::Filter.new(rules)
  end

  def signature(message)
    FakeSNS::Signature.new(message)
  end
end

RSpec.configure do |config|
  config.disable_monkey_patching!

  config.before(:each) { $fake_sns.start }
  config.after(:suite) { $fake_sns.stop }
  config.include SpecHelper

  config.before(:each, :sqs) { $fake_sqs.start }
  config.after(:suite) { $fake_sqs.stop }
end
