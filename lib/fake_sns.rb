Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

require "virtus"
require "verbose_hash_fetch"
require "fake_sns/error"
require "fake_sns/error_response"

require "fake_sns/database"
require "fake_sns/storage"

require "fake_sns/topic_collection"
require "fake_sns/topic"
require "fake_sns/subscription_collection"
require "fake_sns/subscription"

require "fake_sns/message_collection"
require "fake_sns/message"
require "fake_sns/deliver_message"

require "fake_sns/response"
require "fake_sns/action"

# load all the actions
action_files = File.expand_path("../fake_sns/actions/*.rb", __FILE__)
Dir.glob(action_files).each do |file|
  require file
end

module FakeSNS

end
