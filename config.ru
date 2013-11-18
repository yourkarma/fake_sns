$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "fake_sns/server"
run FakeSNS::Server
