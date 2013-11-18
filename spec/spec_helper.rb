ENV["RACK_ENV"] ||= 'test'

require "fake_sns"
FakeSNS.load!

require "rack/test"

require "support/rack"

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.expect_with :rspec do |rspec|
    rspec.syntax = :expect
  end

  config.include Rack::Test::Methods, :rack
  config.include RackHelper, :rack
end
