$LOAD_PATH.unshift File.expand_path('lib', __dir__)
require 'fake_sns/server'
run FakeSNS::Server
