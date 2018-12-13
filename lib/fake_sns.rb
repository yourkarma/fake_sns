Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

require 'virtus'
require 'verbose_hash_fetch'

require 'fake_sns/error'
require 'fake_sns/error_response'

require 'fake_sns/database'
require 'fake_sns/storage'

# Custom Virtus attributes
require 'fake_sns/json_attribute'

require 'fake_sns/filter'
require 'fake_sns/topic_collection'
require 'fake_sns/topic'
require 'fake_sns/subscription_collection'
require 'fake_sns/subscription'
require 'fake_sns/attributes'

require 'fake_sns/signature'
require 'fake_sns/message_collection'
require 'fake_sns/message'
require 'fake_sns/deliver_message'

require 'fake_sns/response'
require 'fake_sns/action'
require 'fake_sns/server'

# load all the actions
action_files = File.expand_path('fake_sns/actions/*.rb', __dir__)
Dir.glob(action_files).each do |file|
  require file
end

# FakeSNS server
module FakeSNS
  def self.server(options)
    app = Server
    enable_logging(app, options[:log]) unless options[:log].nil?
    enable_verbose(app) if options[:verbose]
    set_options(app, options)
    app
  end

  def self.enable_logging(log)
    $stdout.reopen(log, 'w:utf-8')
    $stderr.reopen(log, 'w:utf-8')
    app.enable :logging
  end

  def self.enable_verbose(app)
    require 'fake_sns/show_output'
    app.use FakeSNS::ShowOutput
  end

  def self.set_options(app, options)
    options.each do |key, value|
      app.set key, value
    end
  end
end
