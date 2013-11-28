Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

require "aws-sdk"
require "fake_sns/error"
require "fake_sns/error_response"

require "fake_sns/database"
require "fake_sns/topic"

require "fake_sns/response"

require "fake_sns/action"

require "fake_sns/actions/create_topic"
require "fake_sns/actions/list_topics"

module FakeSNS

end
