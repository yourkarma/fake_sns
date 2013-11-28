ENV["RACK_ENV"] ||= 'test'

require "bundler/setup"
Bundler.require(:default, :test)

require "faraday"

require "support/server_helper"

module SpecHelper

  def sns
    @sns ||= AWS::SNS.new
  end

end

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.expect_with :rspec do |rspec|
    rspec.syntax = :expect
  end

  config.before(:suite) do

    $server = ServerHelper.new
    $server.start

    AWS.config(
      use_ssl:            false,
      sns_endpoint:       $server.host,
      sns_port:           $server.port,
      access_key_id:      "xxx",
      secret_access_key:  "yyy",
    )
  end

  config.after(:suite) do
    $server.stop
  end

  config.before(:each) do
    $server.reset
  end

  config.include(SpecHelper)
end
