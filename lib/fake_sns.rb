Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

require "virtus"
require "verbose_hash_fetch"

require "fake_sns/error"
require "fake_sns/error_response"

require "fake_sns/database"
require "fake_sns/storage"

require "fake_sns/platform_endpoint_collection"
require "fake_sns/platform_endpoint"
require "fake_sns/topic_collection"
require "fake_sns/topic"
require "fake_sns/subscription_collection"
require "fake_sns/subscription"

require "fake_sns/message_collection"
require "fake_sns/message"
require "fake_sns/deliver_message"

require "fake_sns/response"
require "fake_sns/action"
require "fake_sns/server"

# load all the actions
action_files = File.expand_path("../fake_sns/actions/*.rb", __FILE__)
Dir.glob(action_files).each do |file|
  require file
end

module FakeSNS

  def self.server(options)
    app = Server
    if log = options[:log]
      $stdout.reopen(log, "w:utf-8")
      $stderr.reopen(log, "w:utf-8")
      app.enable :logging
    end
    if options[:verbose]
      require "fake_sns/show_output"
      app.use FakeSNS::ShowOutput
    end
    options.each do |key, value|
      app.set key, value
    end
    app
  end

end
