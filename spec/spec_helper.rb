ENV["RACK_ENV"] ||= 'test'

require "bundler/setup"
Bundler.setup

require "aws-sdk"
require "fake_sns/test_integration"
require "fake_sqs/test_integration"


AWS.config(
  use_ssl:            false,
  sqs_endpoint:       "localhost",
  sqs_port:           4568,
  sns_endpoint:       "localhost",
  sns_port:           9293,
  access_key_id:      "fake access key",
  secret_access_key:  "fake secret key",
)

$fake_sns = FakeSNS::TestIntegration.new
$fake_sqs = FakeSQS::TestIntegration.new

module SpecHelper
  def sns
    AWS::SNS.new
  end
end

RSpec.configure do |config|

  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.expect_with :rspec do |rspec|
    rspec.syntax = :expect
  end

  config.before(:each) { $fake_sns.start }
  config.after(:suite) { $fake_sns.stop }
  config.include SpecHelper

  config.before(:each, :sqs) { $fake_sqs.start }
  config.after(:suite) { $fake_sqs.stop }

end
