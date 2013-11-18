require "fake_sns/server"

module RackHelper

  def app
    FakeSNS::Server
  end

  def response_data
    JSON.parse(last_response.body)
  end

end
