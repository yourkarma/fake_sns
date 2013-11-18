require "fake_sns"
require "sinatra/base"

module FakeSNS
  class Server < Sinatra::Base

    configure do
      FakeSNS.load!
    end

    post "/" do
    end

  end
end
